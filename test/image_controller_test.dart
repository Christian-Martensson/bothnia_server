import 'dart:convert';

import 'harness/app.dart';
import 'package:http/http.dart' as http;

Map<String, String> headers = {
  'Content-type': 'application/json',
  'Accept': 'application/json',
};

Future main() async {
  final harness = Harness()..install();

  addImage() async {
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
  }

  test("POST /image", () async {
    final base64String =
        base64Encode(await File("test/test_assets/test.jpg").readAsBytes());
    final res = await http.post(
      "http://94.237.89.244:7777/image",
      headers: headers,
      body: json.encode({
        "name": "My Picture",
        "description": "very pretty",
        "base64": base64String,
        // "photographer": {"id": 1},
        // "user": {"id": 1},
      }),
    );

    expect(
        res,
        hasResponse(
          200,
          body: {
            "id": isInteger,
            "name": "My Picture",
            "description": "very pretty",
            "created": isString,
            "modified": isString,
            "captured": isString,
            "firstPubDate": isString,
            "xCoordinates": isString,
            "yCoordinates": isString,
            "license": isString,
            "usesLeft": isInteger,
            "resolution": isString,
            "isPublicallyAdded": false,
            "photographer": {"id": 1},
            "user": {"id": 1}
          },
        ));

    // expectResponse(res, 200);
  });

  test("POST /image to server with minimum data", () async {
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
          // body: {
          //   "id": 0,
          //   "name": "string",
          //   "description": "string",
          //   "created": "2020-05-10T22:02:32Z",
          //   "modified": "2020-05-10T22:02:32Z",
          //   "captured": "2020-05-10T22:02:32Z",
          //   "firstPubDate": "2020-05-10T22:02:32Z",
          //   "xCoordinates": "string",
          //   "yCoordinates": "string",
          //   "license": "string",
          //   "usesLeft": 0,
          //   "resolution": "string",
          //   "isPublicallyAdded": "false",
          //   "photographer": {"id": 0},
          //   "user": {"id": 0}
          // },
        ));

    // expectResponse(res, 200);
  });

  test("GET /image", () async {
    await addImage();
    final res = await harness.agent.get(
      "/image",
    );

    expect(res, hasResponse(200));
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
