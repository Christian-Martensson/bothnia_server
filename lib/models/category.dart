import '../bothnia_server.dart';

class Category extends ManagedObject<_Category> implements _Category {}

class _Category {
  @Column(primaryKey: true)
  int id;

  String name;

  String description;

  ManagedSet<ImageMetaData> images;
}
