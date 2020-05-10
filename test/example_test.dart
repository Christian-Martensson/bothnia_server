import 'harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  test("GET /example returns 200 ", () async {
    //print("hey");

    final res = await harness.agent.get("/example");

    expectResponse(res, 200);
  });
}
