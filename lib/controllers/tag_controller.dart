import 'package:bothnia_server/bothnia_server.dart';

class TagController extends ManagedObjectController<Tag> {
  TagController(ManagedContext context) : super(context);
  // {
  //   query = Query<Image>(context);
  // }
  // Query<Image> query;

  // @override
  // @Operation.get()
  // Future<Response> getImages() async {
  //   query.join(object: (image) => image.photographer);
  //   query.join(object: (image) => image.user);
  //   query
  //       .join(set: (image) => image.imageTags)
  //       .join(object: (imageToTag) => imageToTag.tag);

  //   return Response.ok(await query.fetch());
  // }
}
