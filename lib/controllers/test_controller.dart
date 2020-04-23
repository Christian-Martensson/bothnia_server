import 'dart:io';

import 'package:aqueduct/aqueduct.dart';
import 'package:mime/mime.dart';

class MyController extends ResourceController {
  MyController() {
    acceptedContentTypes = [ContentType("multipart", "form-data")];
  }

  @Operation.post()
  Future<Response> postForm() async {
    final boundary = request.raw.headers.contentType.parameters["boundary"];
    final transformer = MimeMultipartTransformer(boundary);
    final bodyBytes = await request.body.decode<List<int>>();

    // Pay special attention to the square brackets in the argument:
    final bodyStream = Stream.fromIterable([bodyBytes]);
    final parts = await transformer.bind(bodyStream).toList();

    for (var part in parts) {
      final headers = part.headers;
      final content = await part.toList();

      // Use headers['content-disposition'] to identify the part
      // The byte content of the part is available in 'content'.
    }
  }
}
