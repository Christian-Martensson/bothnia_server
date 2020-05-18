import 'dart:convert';

import 'harness/app.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'utilities.dart';

Map<String, String> headers = {
  'Content-type': 'application/json',
};

Future main() async {
  final harness = Harness()..install();

  test("POST /image basic to actual server", () async {
    final res = await http.post(
      "http://94.237.89.244:7777/image",
      headers: headers,
      body: json.encode({
        "name": "Lodjur med barn",
        "tags": ["lodjur", "skog", "söt"],
      }),
    );

    final map = json.decode(res.body);
    final id = map["id"];

    var uri = Uri.parse('http://94.237.89.244:7777/upload/$id');
    var request = http.MultipartRequest('POST', uri)
      // ..fields['user'] = 'nweiz@google.com'
      ..files.add(await http.MultipartFile.fromPath(
        'content',
        'test/test_assets/lodjur.jpg',
        contentType: MediaType('multipart', 'form-data'),
      ));

    var response = await request.send();
  });

  test("POST /image basic to actual server", () async {
    int counter = 1;

    while (counter < 6) {
      final res = await http.post(
        "http://94.237.89.244:7777/image",
        headers: headers,
        body: json.encode({
          "name": "Picture $counter",
          "description": "Description $counter",
          "base64": await getTestImage(),
          "photographer": {"id": 1},
          // "user": {"id": 1},
          "tags": ["björn", "skog", "skymning"]
        }),
      );

      counter++;
    }
  });

  test("POST /image with minimum data", () async {
    final base64String =
        base64Encode(await File("test/test_assets/test.jpg").readAsBytes());

    final res = await http.post(
      "http://94.237.89.244:7777/image",
      headers: headers,
      body: json.encode({
        "name": "My Test Picture",
      }),
    );

    // final res = await harness.agent.post(
    //   "/image",
    //   body: {
    //     "name": "My Picture",
    //     // "base64": base64String,
    //   },
    // );

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
      "/image",
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
        // "photographer": {"id": 1},
        //  "user": {"id": 1},
        "tags": ["björn"]
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
            "user": {"id": 1},
          },
        ));
  });

  test("GET /image with everything", () async {
    //POST /photographer
    var res;
    res = await harness.agent.post("/photographer", body: {
      "fName": "Chris",
      "lName": "Mar",
    });
    res = await res.body.decode();
    final photographerId = res["id"];

    //POST /user
    res = await harness.agent.post("/user", body: {
      "username": "chrmrt",
      "password": "chrmrt",
      "name": "Christian Mårtensson",
      "type": "photographer",
    });
    res = await res.body.decode();
    final userId = res["id"];

    //POST /image
    res = await harness.agent.post(
      "/image",
      body: {
        "name": "My Picture",
        "base64": await getTestImage(),
        "photographer": {"id": photographerId},
        "user": {"id": userId},
        "tags": ["björn", "älg", "kungafamiljen"],
      },
    );

    res = await harness.agent.get("/image");

    final body = await res.body.decode();
    final imageId = body["id"];

    final res2 = await harness.agent.get(
      "/image/$imageId",
    );

    final res3 = await harness.agent.get(
      "/image",
    );

    expect(
        res2,
        hasResponse(200, body: {
          "id": isInteger,
          "name": "My Picture",
          "description": isNull,
          "base64": isNull,
          "resolution": isNull,
          "created": isString,
          "modified": isString,
          "captured": isNull,
          "firstPubDate": isNull,
          "xCoordinates": isNull,
          "yCoordinates": isNull,
          "license": isNull,
          "usesLeft": isNull,
          "isPublicallyAdded": false,
          "photographer": {
            "id": isInteger,
            "fName": "Chris",
            "lName": "Mar",
            "email": isNull,
            "phone": isNull,
          },
          "user": {
            "id": isInteger,
            "username": "chrmrt",
            "name": "Christian Mårtensson",
            "type": "photographer",
            "canEditor": isFalse,
            "canPhotographer": isFalse,
            "created": isString,
            "modified": isString
          },
          "imageTags": [
            {
              "id": 1,
              "image": {"id": 1},
              "tag": {"id": 1, "name": "björn"}
            },
            {
              "id": 2,
              "image": {"id": 1},
              "tag": {"id": 2, 2: "älg"}
            },
            {
              "id": 3,
              "image": {"id": 1},
              "tag": {"id": 3, "name": "kungafamiljen"}
            }
          ]
        }));
  });

  test("UPDATE /image", () async {
    //POST /image
    var res = await harness.agent.post(
      "/image",
      body: {
        "name": "OldName",
        "base64": await getTestImage(),
      },
    );

    final Map body = await res.body.decode();
    body["name"] = "NewName";
    final int imageId = body["id"] as int;
    body.remove("id");

    res = await harness.agent.put("/image/$imageId", body: body);

    expect(res, hasResponse(200, body: partial({"name": "NewName"})));
  });
  test("DELETE /image", () async {
    //POST /image
    var res = await harness.agent.post(
      "/image",
      body: {
        "name": "My Picture",
        "base64": getTestImage(),
      },
    );

    final body = await res.body.decode();
    final int imageId = body["id"] as int;

    res = await harness.agent.delete("/image/$imageId");

    expect(res, hasResponse(200));
  });

  test("POST /image with shared tags does not cause conflict", () async {
    final res1 = await harness.agent.post(
      "/image",
      body: {
        "name": "My Picture",
        "base64": await getTestImage(),
        "tags": ["älg,björn"],
      },
    );

    final res2 = await harness.agent.post(
      "/image",
      body: {
        "name": "My Picture",
        "base64": await getTestImage(),
        "tags": ["älg, zebra"],
      },
    );

    expect(res1, hasResponse(200));
    expect(res2, hasResponse(200));
  });
}
