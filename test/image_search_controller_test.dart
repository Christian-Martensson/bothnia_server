import 'dart:convert';

import 'package:bothnia_server/utility/helper.dart';

import 'harness/app.dart';
import 'utilities.dart';

Future main() async {
  final harness = Harness()..install();

  test("GET /image/find with everything", () async {
    //POST /photographer
    var res;
    res = await harness.agent.post("/photographer", body: {
      "name": "Christian Mårtensson",
    });
    res = await res.body.decode();
    res = await harness.agent.post("/photographer", body: {
      "name": "Hurley Björk",
    });
    res = await res.body.decode();

    //POST /image
    res = await harness.agent.post(
      "/image",
      body: {
        "name": "My First Picture",
        "base64": await getTestImage(),
        "photographer": {"id": 1},
        "tags": ["natur"],
      },
    );

    res = await harness.agent.post(
      "/image",
      body: {
        "name": "My Second Picture",
        "base64": await getTestImage(),
        "photographer": {"id": 2},
        "tags": ["skog", "natur"]
      },
    );

    res = await harness.agent.post(
      "/image",
      body: {
        "name": "My Third Picture",
        "base64": await getTestImage(),
        "photographer": {"id": 2},
        "tags": ["kungafamiljen", "skog", "natur"],
      },
    );

    res = await harness.agent.post(
      "/image",
      body: {
        "name": "My Fourth Picture",
        "base64": await getTestImage(),
        "photographer": {"id": 2},
        "tags": ["skog"],
      },
    );

    res = await harness.agent.post(
      "/image",
      body: {
        "name": "fourth",
        "base64": await getTestImage(),
        // "photographer": {"id": 2},
        // "tags": ["skog"],
      },
    );
    var now = DateTime.now();
    String test = now.toIso8601String();
    print(test);

    res = await harness.agent.get(
      "/image/search",
      query: {
        // "imageName": "fourth",
        // "photographerId": 2,
        "tags": "skog+natur",
        // "startDate": DateTime(now.year, now.month, now.day).toIso8601String(),
        // "endDate": DateTime(now.year, now.month, now.day + 1).toIso8601String(),
      },
    );

    expect(res, hasResponse(200));
  });

  test("GET /image/find only tags", () async {
    var res;
    res = await harness.agent.post(
      "/tag",
      body: {"name": "tag1"},
    );
    res = await harness.agent.post(
      "/tag",
      body: {"name": "tag2"},
    );
    res = await harness.agent.post(
      "/tag",
      body: {"name": "tag3"},
    );

    var allTags = await harness.agent.get("/tag");

    res = await harness.agent.get(
      "/image/search",
    );

    expect(res, hasResponse(200));
  });
}
