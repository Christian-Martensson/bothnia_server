import 'package:bothnia_server/bothnia_server.dart';

class TagFindController extends ResourceController {
  TagFindController(ManagedContext context) {
    query = Query<Tag>(context);
  }
  Query<Tag> query;

  @Operation.get()
  Future<Response> findTag(@Bind.query('name') String name) async {
    query.where((t) => t.name).equalTo(name);
    final tag = await query.fetchOne();
    if (tag == null) {
      return Response.notFound();
    }
    return Response.ok(tag);
  }
}
