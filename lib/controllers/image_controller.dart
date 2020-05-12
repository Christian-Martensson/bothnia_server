import 'dart:convert';

import '../bothnia_server.dart';

class ImageController extends ResourceController {
  ImageController(this.context) {
    query = Query<Image>(context);
  }
  ManagedContext context;

  Query<Image> query;

  @Operation.post()
  Future<Response> addImage(@Bind.body(ignore: ["tags"]) Image image) async {
    if (image.base64 == null) {
      return Response.badRequest(
          body: {"error": "base64 String missing from request"});
    }

    query.values = image;
    query.values.base64 = null;
    final insertedImage = await query.insert();
    final base64 = base64Decode(image["base64"] as String);
    await File("public/${insertedImage.id}.jpg").writeAsBytes(base64);

    final body = await request.body.decode();
    final List<dynamic> tags = body["tags"] as List<dynamic>;

    var futures = <Future>[];

    if (tags != null) {
      for (var tag in tags) {
        Query<Tag> tagQuery = Query<Tag>(context);
        Query<ImageToTag> imageTagQuery = Query<ImageToTag>(context);

        tagQuery.values.name = tag as String;
        final insertedTag = await tagQuery.insert();
        imageTagQuery.values
          ..tag.id = insertedTag.id
          ..image.id = insertedImage.id;
        //await imageTagQuery.insert();
        futures.add(imageTagQuery.insert());
      }
    }

    await Future.wait(futures);

    query.where((g) => g.id).equalTo(insertedImage.id);
    query.join(object: (image) => image.photographer);
    query.join(object: (image) => image.user);
    query
        .join(set: (image) => image.imageTags)
        .join(object: (imageToTag) => imageToTag.tag);

    var res = await query.fetchOne();

    return Response.ok(res);
  }

  @Operation.get()
  Future<Response> getImages() async {
    query.join(object: (image) => image.photographer);
    query.join(object: (image) => image.user);
    query
        .join(set: (image) => image.imageTags)
        .join(object: (imageToTag) => imageToTag.tag);

    return Response.ok(await query.fetch());
  }

  @Operation.get('id')
  Future<Response> getImage(@Bind.path('id') int id) async {
    query.where((g) => g.id).equalTo(id);
    query.join(object: (image) => image.photographer);
    query.join(object: (image) => image.user);
    query
        .join(set: (image) => image.imageTags)
        .join(object: (imageToTag) => imageToTag.tag);

    var res = await query.fetchOne();

    return Response.ok(res);
  }

  @Operation.put('id')
  Future<Response> updateImage(
      @Bind.path('id') int id, @Bind.body() Image image) async {
    query
      ..where((u) => u.id).equalTo(id)
      ..values = image;

    final updatedImage = await query.updateOne();

    if (image["base64"] != null) {
      final decoded = base64Decode(base64 as String);
      await File("public/${id}.jpg").delete();
      await File("public/${id}.jpg").writeAsBytes(decoded);
    }

    return Response.ok(updatedImage);
  }

  @Operation.delete('id')
  Future<Response> deleteImage(@Bind.path('id') int id) async {
    query.where((image) => image.id).equalTo(id);

    final res = await query.delete();

    await File("public/${id}.jpg").delete();

    return Response.ok(res);
  }
}
