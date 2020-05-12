import 'harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  test("GET /tag/find returns 200 ", () async {
    await harness.agent.post("/tag", body: {
      "name": "fotboll",
    });

    final res =
        await harness.agent.get("/tag/find", query: {"name": "fotboll"});

    expect(
        res,
        hasResponse(200, body: {
          "id": 1,
          "name": "fotboll",
        }));
  });

  test("GET /tag/find on non-existing tag returns 404 ", () async {
    await harness.agent.post("/tag", body: {
      "name": "fotboll",
    });

    final res = await harness.agent.get("/tag/find", query: {"name": "hockey"});

    expect(res, hasResponse(404));
  });
}
