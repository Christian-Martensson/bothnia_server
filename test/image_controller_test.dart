import 'dart:convert';

import 'harness/app.dart';

Future main() async {
  final harness = Harness()..install();
  test("POST /image with minimum data", () async {
    final base64String =
        base64Encode(await File("test/test_assets/test.jpg").readAsBytes());

    final res = await harness.agent.post(
      "/image",
      body: {
        "name": "My Picture",
        "description": "very pretty",
        "base64": base64String,
      },
    );

    expect(
        res,
        hasResponse(
          200,
          body: {
            "id": 0,
            "name": "string",
            "description": "string",
            "created": "2020-05-10T22:02:32Z",
            "modified": "2020-05-10T22:02:32Z",
            "captured": "2020-05-10T22:02:32Z",
            "firstPubDate": "2020-05-10T22:02:32Z",
            "xCoordinates": "string",
            "yCoordinates": "string",
            "license": "string",
            "usesLeft": 0,
            "resolution": "string",
            "isPublicallyAdded": "false",
            "photographer": {"id": 0},
            "user": {"id": 0}
          },
        ));

    // expectResponse(res, 200);
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
        hasResponse(200, body: {
          "id": 1,
          "name": "My Picture",
          "description": null,
          "created": isString, //e.g. 2020-04-26T10:20:32.552493Z
          "modified": isString,
          "captured": null,
          "firstPubDate": null,
          "coordinates": null,
          "license": null,
          "usesLeft": null,
          "isPublicallyAdded": false,
          //"category": {"id": 1},
          "photographer": null,
          "user": null,
          "image": {
            "id": 1,
            "description": null,
            //  "path": isString, //"e.g. "public/2020-04-26 10:20:32.548837Z.jpg",
            "resolution": null,
            "version": 1,
            "created": isString,
            "modified": isString,
            "imageMetaData": {"id": 1}
          }
        }));

    // expectResponse(res, 200);
  });

  test("Photographer uploads picture with tags", () async {});
}
