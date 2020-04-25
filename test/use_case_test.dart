import 'dart:convert';

import 'harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  group("Use case: 1", () {
    test("Photographer uploads picture", () async {
      final res = await harness.agent.post(
        "/upload",
        body: {
          "name": DateTime.now().toString(),
          "content": await getBase64Image(),
        },
      );

      expectResponse(res, 200);
    });

    test("Photographer uploads picture with tags", () async {});
  });
}

getBase64Image() async {
  final image = File("test/test_assets/test.jpg");
  final bytes = await image.readAsBytes();
  final base64Image = base64Encode(bytes);
  return base64Image;
}
