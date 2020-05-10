import 'harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  test("POST /photographer returns 200 ", () async {
    final res = await harness.agent.post("/photographer", body: {
      "fName": "Chris",
      "lName": "Mar",
    });

    //final res = await harness.agent.get("/photographer");
    expect(
        res,
        hasResponse(200, body: {
          "id": 1,
          "fName": "Chris",
          "lName": "Mar",
          "email": null,
          "phone": null,
        }));
  });

  test("GET /photographer returns 200 ", () async {
    await harness.agent.post("/photographer", body: {
      "fName": "Chris",
      "lName": "Mar",
    });

    await harness.agent.post("/photographer", body: {
      "fName": "John",
      "lName": "Appleseed",
      "email": "john.appleseed@gmail.com",
      "phone": "0760300200",
    });

    final res = await harness.agent.get("/photographer");
    expect(
        res,
        hasResponse(200, body: [
          {
            "id": 1,
            "fName": "Chris",
            "lName": "Mar",
            "email": null,
            "phone": null,
          },
          {
            "id": 2,
            "fName": "John",
            "lName": "Appleseed",
            "email": "john.appleseed@gmail.com",
            "phone": "0760300200",
          }
        ]));
  });

  test("PUT /photographer returns 200 ", () async {
    await harness.agent.post("/photographer", body: {
      "fName": "Chris",
      "lName": "Mar",
    });

    final res = await harness.agent.get("/photographer/1");

    Map map = await res.body.decode();
    map.remove("id");
    map["email"] = "some.email@gmail.com";
    map["phone"] = "1234";
    final res2 = await harness.agent.put("photographer/1", body: map);

    expect(
        res2,
        hasResponse(
          200,
          body: {
            "id": 1,
            "fName": "Chris",
            "lName": "Mar",
            "email": "some.email@gmail.com",
            "phone": "1234",
          },
        ));
  });
}
