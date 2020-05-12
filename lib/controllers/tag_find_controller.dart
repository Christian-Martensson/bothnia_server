import 'package:bothnia_server/bothnia_server.dart';

class TagFindController extends ResourceController {
  TagFindController(ManagedContext context) {
    query = Query<Tag>(context);
  }
  Query<Tag> query;

  /// Find a Glove by serial
  @Operation.get()
  Future<Response> findTag(@Bind.query('name') String name) async {
    query.where((t) => t.name).equalTo(name);
    final tag = await query.fetchOne();
    if (tag == null) {
      return Response.notFound();
    }
    return Response.ok(tag);

    // var instQuery = query.join(object: (g) => g.installation);
    // instQuery.where((installation) => installation.id).equalTo(id);
    // query.where((g) => g.serial).equalTo(name);
    // query
    //     .join(object: (u) => u.operator)
    //     .returningProperties((op) => [op.extId, op.metadata]);
    // var glove = await query.fetchOne();
    // if (glove == null) {
    //   return Response.notFound();
    // }
    // return Response.ok(glove);
  }
}
