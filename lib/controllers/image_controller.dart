import 'dart:convert';

import '../bothnia_server.dart';

/* class ImageController extends ManagedObjectController<Image> {
  ImageController(ManagedContext context) : super(context);

}
 */

class ImageController extends ResourceController {
  ImageController(this.context) {
    imageQuery = Query<Image>(context);
  }
  ManagedContext context;

  Query<Image> imageQuery;

  // @Operation.post()
  // Future<Response> addImage() async {
  //   //todo: extract EXIF and add capture time

  //   final Map<String, dynamic> body = await request.body.decode();

  //   final image = base64Decode(body["content"] as String);

  //   imageQuery.values
  //     ..name = body["name"] as String
  //     ..xCoordinates;

  //   //todo: check that the name doesn't have the .jpg suffix already

  //   // imageQuery.values
  //   //   ..version = 1
  //   //   ..imageMetaData.id = insertedMeta.id;

  //   final insertedImage = await imageQuery.insert();

  //   final file =
  //       await File("public/${insertedImage.id}.jpg").writeAsBytes(image);

  //   // return it the same way as a join would look
  //   final map = insertedMeta.asMap();
  //   map["image"] = insertedImage.asMap();
  //   return Response.ok(map);
  // }
}
