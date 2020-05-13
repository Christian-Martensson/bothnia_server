import 'package:bothnia_server/bothnia_server.dart';
import 'package:bothnia_server/utility/helper.dart';

class ImageSearchController extends ResourceController {
  ImageSearchController(ManagedContext context) {
    query = Query<Image>(context);
    imageTagQuery = Query<ImageToTag>(context);
  }
  Query<Image> query;
  Query<ImageToTag> imageTagQuery;

  @Operation.get()
  Future<Response> findTag({
    @Bind.query('imageName') String imageName,
    @Bind.query('photographerId') int photographerId,
    // @Bind.query('tags') String tagString,
    // @Bind.query('startDate') String startDate,
    // @Bind.query('endDate') String endDate,
  }) async {
    List<String> tags;

    // return Response.ok(await query.fetch());
    // TAGS
    // are seperated by "&", e.g. "tag1&tag2&tag3"
    // if (tagString != null) {
    //   tags = tagString.split("#");
    //   imageTagQuery.where((it) => it.tag.name).oneOf(tags);

    //   final imageToTags = await imageTagQuery.fetch();
    //   final imageIds = imageToTags.map((i) => i.image.id).toSet().toList();

    //   query.where((i) => i.id).oneOf(imageIds);
    // }

    // PHOTOGRAPHER
    if (photographerId != null) {
      query.where((i) => i.photographer.id).equalTo(photographerId);
    }

    // IMAGENAME
    if (imageName != null) {
      query.where((i) => i.name).contains(imageName, caseSensitive: false);
      // like(imageName);
    }

    // DATES
    // only startDate is given
    // if (startDate != null && endDate == null) {
    //   DateTime d = DateTime.parse(startDate);

    //   query
    //       .where((i) => i.created)
    //       .greaterThanEqualTo(DateTime(d.year, d.month, d.day));
    // }
    // // only endDate is given
    // if (startDate == null && endDate != null) {
    //   DateTime d = DateTime.parse(endDate);
    //   query
    //       .where((i) => i.created)
    //       .lessThanEqualTo(DateTime(d.year, d.month, d.day));
    // }
    // // date interval is given
    // if (startDate != null && endDate != null) {
    //   DateTime start = DateTime.parse(startDate);
    //   DateTime end = DateTime.parse(endDate);

    //   query.where((i) => i.created).between(
    //         DateTime(start.year, start.month, start.day),
    //         DateTime(end.year, end.month, end.day),
    //       );
    // }

    query.sortBy((i) => i.created, QuerySortOrder.descending);

    query.join(object: (image) => image.photographer);
    query.join(object: (image) => image.user);
    query
        .join(set: (image) => image.imageTags)
        .join(object: (imageToTag) => imageToTag.tag);

    List<Image> images = await query.fetch();
    if (images == null) {
      return Response.notFound();
    }
    List<Map<String, dynamic>> cleanedList = images.map(cleanTags).toList();

    // cleanedList[0]["tags"];

    // var randomList = [];
    // randomList.where((each) => each["hey"]);

    var newList = cleanedList.where((each) {
      final test = each["tags"] as List;
      bool matchesAllTags = true;
      for (var tag in tags) {
        if (!test.contains(tag)) {
          matchesAllTags = false;
        }
      }
      // bool isTrue = test.contains(tags);
      return matchesAllTags;
    }).toList();

    return Response.ok(newList);

    return Response.ok(await fetchCleanedImageWithEverything(query));
  }
}
