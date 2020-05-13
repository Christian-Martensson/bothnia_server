import 'dart:convert';

import 'package:bothnia_server/utility/helper.dart';

import 'harness/app.dart';
import 'utilities.dart';

Future main() async {
  final harness = Harness()..install();

  test("GET /image with everything", () async {
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
        "tags": ["älg"],
      },
    );

    res = await harness.agent.post(
      "/image",
      body: {
        "name": "My Second Picture",
        "base64": await getTestImage(),
        "photographer": {"id": 2},
        "tags": [
          "björn",
        ],
      },
    );

    res = await harness.agent.post(
      "/image",
      body: {
        "name": "My Third Picture",
        "base64": await getTestImage(),
        "photographer": {"id": 2},
        "tags": [
          "älg",
        ],
      },
    );

    res = await harness.agent.get(
      "/image/find",
      query: {
        //"queryString": null,
        //  "photographerId": 1,
        "tags": ["björn"],
        // "startDate": null,
        // "endDate": null,
      },
    );

    expect(res, hasResponse(200));
  });
}
