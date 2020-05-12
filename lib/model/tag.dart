import 'package:bothnia_server/bothnia_server.dart';

class Tag extends ManagedObject<_Tag> implements _Tag {}

class _Tag {
  @primaryKey
  int id;
  @Column(unique: true)
  String name;

  //String color;

  ManagedSet<ImageToTag> imageTags;
}
