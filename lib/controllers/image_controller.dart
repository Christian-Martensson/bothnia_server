import 'dart:convert';

import '../bothnia_server.dart';

class ImageController extends ResourceController {
  ImageController(this.context) {
    query = Query<Image>(context);
  }
  ManagedContext context;

  Query<Image> query;

  @Operation.post()
  Future<Response> addImage(@Bind.body() Image image) async {
    // can we bind image and add base64 seperately?

    //final Map<String, dynamic> body = await request.body.decode();
    //return Response.ok({"key": "value"});

    query.values = image;
    //query.values.base64 = null;
    final insertedImage = await query.insert();

    final base64 = base64Decode(image["base64"] as String);
    await File("public/${insertedImage.id}.jpg").writeAsBytes(base64);

    return Response.ok(insertedImage);
  }

  @Operation.get()
  Future<Response> getImages() async {
    var res = await query.fetch();
    return Response.ok(res);
    // can we bind image and add base64 seperately?

    //final Map<String, dynamic> body = await request.body.decode();
  }
}
