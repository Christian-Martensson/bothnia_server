import 'package:http/http.dart' as http;
import 'harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  test("GET /doc returns 200 with html", () async {
    final res = await harness.agent.get("/doc");

    expectResponse(res, 200);
  });
}
