import 'package:http/http.dart' as http;
import 'harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  test("GET /example returns 200 {'key': 'value'}", () async {
    expectResponse(await harness.agent.get("/example"), 200,
        body: {"key": "value"});
  });

  test("GET /apidoc returns 200 with html", () async {
    final res = await harness.agent.get("/apidoc/client.html");

    print(res.body);
  });
}

Future<http.Response> getFile(String path,
    {Map<String, String> headers}) async {
  return http.get("http://localhost:8888/files$path", headers: headers);
}
