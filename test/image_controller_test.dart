import 'dart:convert';

import 'harness/app.dart';
import 'package:http/http.dart' as http;

Map<String, String> headers = {
  'Content-type': 'application/json',
//  'Accept': 'application/json',
};

Future main() async {
  final harness = Harness()..install();

  test("POST /image basic to actual server", () async {
    final base64String =
        base64Encode(await File("test/test_assets/test.jpg").readAsBytes());
    final res = await http.post(
      "http://94.237.89.244:7777/image",
      headers: headers,
      body: json.encode({
        "name": "My Picture",
        "description": "very pretty",
        "base64": base64String,
        "photographer": {"id": 1},
        "user": {"id": 1},
      }),
    );
  });

  test("POST /image with minimum data", () async {
    final base64String =
        base64Encode(await File("test/test_assets/test.jpg").readAsBytes());
    final res = await harness.agent.post(
      "/image",
      body: {
        "name": "My Picture",
        "base64": base64String,
      },
    );

    expect(
        res,
        hasResponse(
          200,
          body: {
            "id": isInteger,
            "name": "My Picture",
            "description": isNull,
            "base64": isNull,
            "created": isString,
            "modified": isString,
            "captured": isNull,
            "firstPubDate": isNull,
            "xCoordinates": isNull,
            "yCoordinates": isNull,
            "license": isNull,
            "usesLeft": isNull,
            "resolution": isString,
            "isPublicallyAdded": false,
            "photographer": {"id": 1},
            "user": {"id": 1}
          },
        ));
  });

  test("POST /image with maximum data", () async {
    final String timeNow = DateTime.now().toIso8601String();
    final base64String =
        base64Encode(await File("test/test_assets/test.jpg").readAsBytes());
    final res = await harness.agent.post(
      "http://94.237.89.244:7777/image",
      body: {
        "name": "My Picture",
        "description": "the best picture",
        "base64": base64String,
        "resolution": "2880x1880",
        "captured": timeNow,
        "firstPubDate": timeNow,
        "xCoordinates": "40.689263",
        "yCoordinates": "-74.044505",
        "license": "Köpt från GreatMedia AB för begränsad användning: 5 gånger",
        "usesLeft": 5,
        "photographer": {"id": 1},
        "user": {"id": 1},
      },
    );

    expect(
        res,
        hasResponse(
          200,
          body: {
            "id": isInteger,
            "name": "My Picture",
            "description": "the best picture",
            "base64": isNull,
            "resolution": isString,
            "created": isString,
            "modified": isString,
            "captured": timeNow,
            "firstPubDate": timeNow,
            "xCoordinates": isNull,
            "yCoordinates": isNull,
            "license": isNull,
            "usesLeft": isNull,
            "isPublicallyAdded": false,
            "photographer": {"id": 1},
            "user": {"id": 1}
          },
        ));
  });

  test("GET /image", () async {
    //POST [Photographer]
    var res;
    res = await harness.agent.post("/photographer", body: {
      "fName": "Chris",
      "lName": "Mar",
    });
    res = await res.body.decode();
    final photographerId = res["id"];

    //POST [User]
    res = await harness.agent.post("/user", body: {
      "username": "chrmrt",
      "password": "chrmrt",
      "name": "Christian Mårtensson",
      "type": "photographer",
    });
    res = await res.body.decode();
    final userId = res["id"];

    //POST [Image]
    final base64String =
        base64Encode(await File("test/test_assets/test.jpg").readAsBytes());
    res = await harness.agent.post(
      "/image",
      body: {
        "name": "My Picture",
        "base64": base64String,
        "photographer": {"id": photographerId},
        "user": {"id": userId}
      },
    );

    final body = await res.body.decode();
    final id = body["id"];

    res = await harness.agent.get(
      "/image/$id",
    );

    expect(
        res,
        hasResponse(
          200,
        ));
  });

  // test("POST /image with minimum data", () async {
  //   final base64String =
  //       base64Encode(await File("test/test_assets/test.jpg").readAsBytes());

  //   final res = await harness.agent.post(
  //     "/image",
  //     body: {
  //       "name": "My Picture",
  //       "base64": base64String,
  //     },
  //   );

  //   expect(
  //       res,
  //       hasResponse(200, body: {
  //         "id": 1,
  //         "name": "My Picture",
  //         "description": null,
  //         "created": isString, //e.g. 2020-04-26T10:20:32.552493Z
  //         "modified": isString,
  //         "captured": null,
  //         "firstPubDate": null,
  //         "coordinates": null,
  //         "license": null,
  //         "usesLeft": null,
  //         "isPublicallyAdded": false,
  //         //"category": {"id": 1},
  //         "photographer": null,
  //         "user": null,
  //         "image": {
  //           "id": 1,
  //           "description": null,
  //           //  "path": isString, //"e.g. "public/2020-04-26 10:20:32.548837Z.jpg",
  //           "resolution": null,
  //           "version": 1,
  //           "created": isString,
  //           "modified": isString,
  //           "imageMetaData": {"id": 1}
  //         }
  //       }));

  //   // expectResponse(res, 200);
  // });

  test("Photographer uploads picture with tags", () async {});
}
