import 'package:bothnia_server/bothnia_server.dart';

class Tag extends ManagedObject<_Tag> implements _Tag {
  static Future<Tag> find(ManagedContext context, String name) async {
    var query = Query<Tag>(context);
    query.where((g) => g.name).equalTo(name);
    return await query.fetchOne();
  }
}

class _Tag {
  @primaryKey
  int id;

  @Column(unique: true)
  String name;

  //String color;

  ManagedSet<ImageToTag> imageTags;
}
