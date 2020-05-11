import 'harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  test("POST /tag returns 200 ", () async {
    final res = await harness.agent.post("/tag", body: {
      "name": "fotboll",
    });

    expect(
        res,
        hasResponse(200, body: {
          "id": 1,
          "name": "fotboll",
        }));
  });
}
