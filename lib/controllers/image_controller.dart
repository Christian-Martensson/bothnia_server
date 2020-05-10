import 'dart:convert';

import '../bothnia_server.dart';

class ImageController extends ResourceController {
  ImageController(this.context) {
    imageQuery = Query<Image>(context);
  }
  ManagedContext context;

  Query<Image> imageQuery;

  @Operation.post()
  Future<Response> addImage(@Bind.body() Image image) async {
    // can we bind image and add base64 seperately?

    //final Map<String, dynamic> body = await request.body.decode();

    imageQuery.values = image;
    imageQuery.values.base64 = null;
    final insertedImage = await imageQuery.insert();

    final base64 = base64Decode(image["base64"] as String);
    await File("public/${insertedImage.id}.jpg").writeAsBytes(base64);

    return Response.ok(insertedImage);
  }
}
