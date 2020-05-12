import '../bothnia_server.dart';

findTag(ManagedContext context, String name) async {
  Query<Tag> query = Query<Tag>(context);
  query.where((t) => t.name).equalTo(name);
  return await query.fetchOne();
}

cleanTags(Image res) {
  if (res["imageTags"] == null) return res;
  Map<String, dynamic> cleanedImage = res.asMap();

  cleanedImage["imageTags"] =
      res["imageTags"].map((f) => f["tag"]["name"]).toList();
  return cleanedImage;
}
