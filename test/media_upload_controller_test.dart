import 'harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  test("GET /example returns 200 ", () async {
    final res = await harness.agent.post("/example");

    expectResponse(res, 200);
  });
}
