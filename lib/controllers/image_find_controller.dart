import 'package:bothnia_server/bothnia_server.dart';
import 'package:bothnia_server/utility/helper.dart';

class ImageFindController extends ResourceController {
  ImageFindController(ManagedContext context) {
    query = Query<Image>(context);
    imageTagQuery = Query<ImageToTag>(context);
  }
  Query<Image> query;
  Query<ImageToTag> imageTagQuery;

  @Operation.get()
  Future<Response> findTag({
    @Bind.query('queryString') String queryString,
    @Bind.query('photographerId') int photographerId,
    @Bind.query('tags') List<String> tags,
    @Bind.query('startDate') String startDate,
    @Bind.query('startDate') String endDate,
  }) async {
    query.join(object: (image) => image.photographer);
    query.join(object: (image) => image.user);
    query
        .join(set: (image) => image.imageTags)
        .join(object: (imageToTag) => imageToTag.tag);
    return Response.ok(await query.fetch());
    // return Response.ok({"body": "body"});
    if (queryString != null && queryString.isNotEmpty) {
      query.where((i) => i.name).contains(queryString);
    }
    if (photographerId != null && photographerId != 0) {
      query.where((i) => i.photographer.id).equalTo(photographerId);
    }
    if (tags != null) {
      imageTagQuery.where((i) => i.tag.name).oneOf(tags);
      var imageTags = await imageTagQuery.fetch();
      return Response.ok(imageTags);

      //query.where((f) => f.imageTags).equalTo(imageTags)

      query
          .join(set: (image) => image.imageTags)
          .join(object: (imageToTag) => imageToTag.tag)
          .where((t) => tags.contains(t.name))
          .equalTo(true);
      //  .contains(tags[0]);

      //query.where((i) => i.imageTags);
      // .contains(tags[0]);
      // .where((t) => tags.contains(t.name));
    }

    if (startDate != null && endDate == null) {
      DateTime d = DateTime.parse(startDate);

      DateTime startOfDay = DateTime(d.year, d.month, d.day);
      DateTime endOfDay = DateTime(d.year, d.month, d.day + 1);

      query.where((i) => i.captured).between(
            DateTime(d.year, d.month, d.day),
            DateTime(d.year, d.month, d.day + 1),
          );
    }

    if (startDate == null && endDate != null) {
      DateTime d = DateTime.parse(endDate);

      DateTime startOfDay = DateTime(d.year, d.month, d.day);
      DateTime endOfDay = DateTime(d.year, d.month, d.day + 1);

      query.where((i) => i.captured).between(
            DateTime(d.year, d.month, d.day),
            DateTime(d.year, d.month, d.day + 1),
          );
    }

    if (startDate != null && endDate != null) {
      DateTime start = DateTime.parse(startDate);
      DateTime end = DateTime.parse(endDate);
      query.where((i) => i.captured).between(start, end);
    }

    final images = await query.fetch();
    if (images == null) {
      return Response.notFound();
    }

    final cleaned = images.map(cleanTags).toList();
    return Response.ok(cleaned);
  }
}
