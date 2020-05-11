import 'dart:convert';

import 'harness/app.dart';
import 'package:http/http.dart' as http;

Map<String, String> headers = {
  'Content-type': 'application/json',
};

Future main() async {
  final harness = Harness()..install();

  test("POST /imagetag adds tag to image", () async {
    TestResponse res;
    final base64String =
        base64Encode(await File("test/test_assets/test.jpg").readAsBytes());
    res = await harness.agent.post(
      "/image",
      body: {
        "name": "My Picture",
        "base64": base64String,
      },
    );

    res = await harness.agent.post(
      "/tag",
      body: {
        "name": "björn",
      },
    );

    res = await harness.agent.post(
      "/imagetag",
      body: {
        "tag": {"id": 1},
        "image": {"id": 1},
      },
    );

    expectResponse(res, 200);
  });
}
