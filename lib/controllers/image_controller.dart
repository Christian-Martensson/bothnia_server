import 'dart:convert';

import 'package:bothnia_server/utility/helper.dart';

import '../bothnia_server.dart';

class ImageController extends ResourceController {
  ImageController(this.context) {
    query = Query<Image>(context);
  }
  ManagedContext context;

  Query<Image> query;

  @Operation.post()
  Future<Response> addImage(@Bind.body(ignore: ["tags"]) Image image) async {
    query.values = image;

    final insertedImage = await query.insert();

    final body = await request.body.decode();
    final List<dynamic> tags = body["tags"] as List<dynamic>;

    var futures = <Future>[];

    if (tags != null) {
      for (var tag in tags) {
        final Query<Tag> tagQuery = Query<Tag>(context);
        final Query<ImageToTag> imageTagQuery = Query<ImageToTag>(context);
        final Query<Tag> findTagQuery = Query<Tag>(context);
        findTagQuery.where((t) => t.name).equalTo(tag as String);
        final fetchedTag = await findTagQuery.fetchOne();

        if (fetchedTag == null) {
          tagQuery.values.name = tag as String;
          final insertedTag = await tagQuery.insert();
          imageTagQuery.values
            ..tag.id = insertedTag.id
            ..image.id = insertedImage.id;

          futures.add(imageTagQuery.insert());
        } else {
          imageTagQuery.values
            ..tag.id = fetchedTag.id
            ..image.id = insertedImage.id;

          futures.add(imageTagQuery.insert());
        }
      }
    }

    await Future.wait(futures);

    query.where((g) => g.id).equalTo(insertedImage.id);
    return Response.ok(
        await fetchCleanedImageWithEverything(query, fetchOne: true));
  }

  @Operation.get()
  Future<Response> getImages() async {
    return Response.ok(await fetchCleanedImageWithEverything(query));
  }

  @Operation.get('id')
  Future<Response> getImage(@Bind.path('id') int id) async {
    query.where((g) => g.id).equalTo(id);
    return Response.ok(
        await fetchCleanedImageWithEverything(query, fetchOne: true));
  }

  //TODO: test if works properly
  @Operation.put('id')
  Future<Response> updateImage(
      @Bind.path('id') int id, @Bind.body() Image image) async {
    query
      ..where((u) => u.id).equalTo(id)
      ..values = image;

    final updatedImage = await query.updateOne();

    query = Query<Image>(context);
    query.where((i) => i.id).equalTo(updatedImage.id);

    return Response.ok(
        await fetchCleanedImageWithEverything(query, fetchOne: true));
  }

  @Operation.delete('id')
  Future<Response> deleteImage(@Bind.path('id') int id) async {
    query.where((image) => image.id).equalTo(id);
    return Response.ok(await query.delete());
  }
}
