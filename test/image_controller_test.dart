import 'dart:convert';

import 'harness/app.dart';
import 'package:http/http.dart' as http;

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
        "name": "My Picture",
        "description": "very pretty",
        "base64": await getTestImage(),
        "photographer": {"id": 1},
        "user": {"id": 1},
        "tags": ["testTag1", "testTag2"]
      }),
    );

    print(res.body);
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
        "imageTags": [
          {
            "id": 1,
            "image": {"id": 1},
            "tag": {"id": 1, "name": "björn"}
          }
        ]
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

    final body = await res.body.decode();
    final imageId = body["id"];

    final List<String> tags = ["björn", "älg", "kungafamiljen"];
    tags.forEach((tag) async {
      //POST /tag
      final tagId = await createTag(harness, tag);
      //POST /imagetag
      await addTagToImage(harness, imageId, tagId);
    });

    // await Future.delayed(const Duration(seconds: 3)).then((onValue) async {
    //   res = await harness.agent.get(
    //     "/image/$imageId",
    //   );
    // });
    res = await harness.agent.get(
      "/image/$imageId",
    );

    expect(
        res,
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
}
