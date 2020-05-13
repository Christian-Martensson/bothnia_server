import 'dart:io';

import 'package:aqueduct/aqueduct.dart';
import 'package:mime/mime.dart';
import 'package:http_server/http_server.dart';

class MediaUploadController extends ResourceController {
  MediaUploadController() {
    acceptedContentTypes = [ContentType("multipart", "form-data")];
  }

  @Operation.post('id')
  Future<Response> postMultipartForm(@Bind.path('id') int id) async {
    final transformer = MimeMultipartTransformer(
        request.raw.headers.contentType.parameters["boundary"]);
    final bodyStream =
        Stream.fromIterable([await request.body.decode<List<int>>()]);
    final parts = await transformer.bind(bodyStream).toList();

    for (var part in parts) {
      HttpMultipartFormData multipart = HttpMultipartFormData.parse(part);

      final ContentType contentType = multipart.contentType;

      final content = multipart.cast<List<int>>();

      //TODO: remove file if already exists
      final filePath = "public/$id.jpg";

      IOSink sink = File(filePath).openWrite();
      await for (List<int> item in content) {
        sink.add(item);
      }
      await sink.flush();
      await sink.close();
    }

    return Response.ok({});
  }
}
