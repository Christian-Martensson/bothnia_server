import 'package:bothnia_server/bothnia_server.dart';

class Tag extends ManagedObject<_Tag> implements _Tag {}

class _Tag {
  @Column(primaryKey: true)
  int id;

  String name;

  String color;

  ManagedSet<ImageToTag> imagesTags;
}
