import 'dart:convert';

import 'harness/app.dart';
import 'package:http/http.dart' as http;

Future main() async {
  Harness harness = new Harness()..install();

  Map checkUser(TestResponse response) {
    expect(
        response,
        hasResponse(200, body: {
          "id": isNotNull,
          "created": isTimestamp,
          "modified": isTimestamp,
          "username": "chrmrt",
          "name": "Christian Mårtensson",
          "type": "photographer",
          //"images": null,
          "canEditor": false,
          "canPhotographer": false,
        }));
    return response.body.as<Map>();
  }

  Future<Map> createUser() async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
    };
    // var response = await harness.adminAgent.post("/user", body: {
    var response = await http.post(
      "http://94.237.89.244:7777/user",
      headers: headers,
      body: json.encode({
        "username": "chrmrt",
        "name": "Christian Mårtensson",
        "type": "admin",
        "password": "chrmrt",
      }),
    );

    print(response);
    // return checkUser(response);
  }

  test("POST /user creates a User", () async {
    await createUser();
  });

  test("GET /user/:username returns previously created User", () async {
    await createUser();
    var response = await harness.adminAgent.get("/user/gokr");
    checkUser(response);
  });

  test("GET /self/:userid gives User including Installations", () async {
    var userMap = await createUser();
    var agent = await harness.createExistingAgent("gokr");
    await harness.adminAgent.post("/user/${userMap["id"]}/installation/1");
    var response = await agent.get("/self/gokr");
    expect(
        response,
        hasResponse(200, body: {
          "id": isInteger,
          "email": isString,
          "name": "Göran Krampe",
          "created": isTimestamp,
          "modified": isTimestamp,
          "type": "bioservoUser",
          "canInstallation": false,
          "canBioservoUser": false,
          "canDistributor": false,
          "canSuperUser": false,
          "canDebug": false,
          "username": "gokr",
          "distributor": null,
          "customer": null,
          "superUserInstallations": isList,
          "userInstallations": [
            {
              "id": isInteger,
              "user": {"id": isInteger},
              "installation": {
                "id": isInteger,
                "created": isTimestamp,
                "modified": isTimestamp,
                "extId": "whatever",
                "name": "Inst",
                "description": "Cool",
                "location": null,
                "metadata": {"some": 42},
                "customer": {"id": 1}
              }
            }
          ]
        }));
  });

  // test("GET /self/:userid gives 403 for other User than self", () async {
  //   await createUser();
  //   var agent = await harness.createSuperAgent();
  //   var response = await agent.get("/self/gokr");
  //   expect(response, hasResponse(400));
  // });

  test(
      "GET /user/:userid/installation gives zero Installations if there are none",
      () async {
    var userMap = await createUser();
    var response =
        await harness.adminAgent.get("/user/${userMap["id"]}/installation");
    expect(response, hasResponse(200, body: []));
  });

  test("DELETE /user/:userid/installation/:id removes access to Installation",
      () async {
    var userMap = await createUser();
    await harness.adminAgent.post("/user/${userMap["id"]}/installation/1");
    var response = await harness.adminAgent
        .delete("/user/${userMap["id"]}/installation/1");
    expect(response, hasResponse(200));
    response =
        await harness.adminAgent.get("/user/${userMap["id"]}/installation");
    expect(response, hasResponse(200, body: []));
  });

  test(
      "GET /installation/1/users gets all Users with access to Installation if it exists",
      () async {
    var userMap = await createUser();
    await harness.adminAgent.post("/user/${userMap["id"]}/installation/1");
    var response = await harness.adminAgent.get("/installation/1/users");
    expect(
        response,
        hasResponse(200, body: [
          {
            "id": 2,
            "email": "goran.krampe@bioservo.com",
            "created": isTimestamp,
            "modified": isTimestamp,
            "type": "bioservoUser",
            "customer": null,
            "distributor": null,
            "canInstallation": false,
            "canBioservoUser": false,
            "canDistributor": false,
            "canSuperUser": false,
            "canDebug": false,
            "username": "gokr",
            "name": "Göran Krampe"
          }
        ]));
  });

  test(
      "GET /installation/1/users gets zero Users with access to Installation if there are none",
      () async {
    await createUser();
    var response = await harness.adminAgent.get("/installation/1/users");
    expect(response, hasResponse(200, body: []));
  });

  test("GET /installation/99/users gets 404 for missing Installation",
      () async {
    var response = await harness.adminAgent.get("/installation/99/users");
    expect(response, hasResponse(404));
  });
}
