import 'dart:convert';
import 'dart:io';

import 'package:aqueduct/aqueduct.dart';

class UploadController extends ResourceController {
  UploadController(this.context);
  ManagedContext context;

  @Operation.post()
  Future<Response> postImage() async {
    final body = await request.body.decode();
    final String name = body["name"] as String;
    final String base64Image = body["content"] as String;
    final image = base64Decode(base64Image);

    //todo: check that the name doesn't have the .jpg suffix already
    await File("public/$name.jpg").writeAsBytes(image);

    return Response.ok(body);
  }
}
