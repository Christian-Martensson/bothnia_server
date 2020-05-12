import '../bothnia_server.dart';

findTag(ManagedContext context, String name) async {
  Query<Tag> query = Query<Tag>(context);
  query.where((t) => t.name).equalTo(name);
  return await query.fetchOne();
}
