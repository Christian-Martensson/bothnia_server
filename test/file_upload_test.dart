import 'dart:convert';
import 'package:http/http.dart' as http;
import 'harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  test("POST /test returns 200", () async {
    final image = File("test/test_assets/test.jpg");
    final bytes = await image.readAsBytes();
    final base64Image = base64Encode(bytes);

    final res = await harness.agent.post(
      "/upload",
      body: {"content": base64Image},
    );

    expectResponse(res, 200);
  });

  test("POST /test adds file to server", () async {
    final image = File("test/test_assets/test.jpg");
    final bytes = await image.readAsBytes();
    final base64Image = base64Encode(bytes);

    final res = await harness.agent.post(
      "/upload",
      body: {
        "name": DateTime.now().toString(),
        "content": base64Image,
      },
    );

    expectResponse(res, 200);
  });
}

Future<http.Response> getFile(String path,
    {Map<String, String> headers}) async {
  return http.get("http://localhost:8888/files$path", headers: headers);
}
