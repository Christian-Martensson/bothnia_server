import 'harness/app.dart';

Future<dynamic> createTag(Harness harness, String name) async {
  final res = await harness.agent.post(
    "/tag",
    body: {
      "name": name,
    },
  );
  var body = await res.body.decode();
  return body["id"];
}

Future<dynamic> addTagToImage(
    Harness harness, dynamic imageId, dynamic tagId) async {
  final res = await harness.agent.post(
    "/imagetag",
    body: {
      "image": {"id": imageId},
      "tag": {"id": tagId},
    },
  );
  var body = await res.body.decode();
  return body["id"];
}
