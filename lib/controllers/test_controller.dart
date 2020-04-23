import 'dart:io';

import 'package:aqueduct/aqueduct.dart';
import 'package:mime/mime.dart';

class TestController extends ResourceController {
  TestController(this.context);
  ManagedContext context;

  @Operation.post()
  Future<Response> postImage() async {
    final file = File("web/client.html");

    return Response.ok(file.readAsStringSync())
      ..contentType = ContentType.html; //ContentType("application", "html");
  }
}
