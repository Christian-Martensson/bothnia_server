import '../bothnia_server.dart';

findTag(ManagedContext context, String name) async {
  Query<Tag> query = Query<Tag>(context);
  query.where((t) => t.name).equalTo(name);
  return await query.fetchOne();
}

cleanTags(Image res) {
  if (res["imageTags"] == null) return res;
  Map<String, dynamic> cleanedImage = res.asMap();

  cleanedImage["tags"] = res["imageTags"].map((f) => f["tag"]["name"]).toList();
  cleanedImage.remove("imageTags");
  return cleanedImage;
}

Future<dynamic> fetchCleanedImageWithEverything(Query<Image> query,
    {bool fetchOne = false}) async {
  query.join(object: (image) => image.photographer);
  query.join(object: (image) => image.user);
  query
      .join(set: (image) => image.imageTags)
      .join(object: (imageToTag) => imageToTag.tag);

  var res;
  if (fetchOne) {
    final image = await query.fetchOne();
    res = cleanTags(image);
  } else {
    final images = await query.fetch();
    res = images.map(cleanTags).toList();
  }

  return res;
}
