import 'dart:convert';

import 'package:aqueduct/aqueduct.dart';
import 'package:bothnia_server/bothnia_server.dart';

/* class ImageController extends ManagedObjectController<Image> {
  ImageController(ManagedContext context) : super(context);

}
 */

class ImageController extends ResourceController {
  ImageController(this.context) {
    imageQuery = Query<Image>(context);
    metaQuery = Query<ImageMetaData>(context);
  }
  ManagedContext context;

  Query<Image> imageQuery;
  Query<ImageMetaData> metaQuery;

  @Operation.post()
  Future<Response> createOriginal() async {
    //todo: extract EXIF and add capture time

    final body = await request.body.decode();

    metaQuery.values
      ..name = body["name"] as String
      ..category.id = body["category"] as int;

    final insertedMeta = await metaQuery.insert();

    final image = base64Decode(body["image"]["content"] as String);

    //todo: check that the name doesn't have the .jpg suffix already

    imageQuery.values
      ..version = 1
      ..imageMetaData.id = insertedMeta.id;

    final insertedImage = await imageQuery.insert();

    final file =
        await File("public/${insertedImage.id}.jpg").writeAsBytes(image);

    // return it the same way as a join would look
    final map = insertedMeta.asMap();
    map["image"] = insertedImage.asMap();
    return Response.ok(map);
  }
}
