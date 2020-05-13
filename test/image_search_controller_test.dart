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
        "tags": ["skog"],
      },
    );

    res = await harness.agent.get(
      "/image/search",
      query: {
        //"queryString": null,
        "photographerId": 1,
        // "tags": ["skog"],
        // "startDate": null,
        // "endDate": null,
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
