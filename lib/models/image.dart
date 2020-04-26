import 'package:bothnia_server/bothnia_server.dart';

class Image extends ManagedObject<_Image> implements _Image {
  @override
  void willInsert() {
    created = DateTime.now().toUtc();
    modified = DateTime.now().toUtc();
  }

  @override
  void willUpdate() {
    modified = DateTime.now().toUtc();
  }
}

class _Image {
  @primaryKey
  int id;

  //isNull if original
  @Column(nullable: true)
  String description; //e.g. "cropped and saturated"

  String path;

  @Column(nullable: true)
  String resolution;

  int version;

  DateTime created;

  DateTime modified;

  @Relate(#versions, isRequired: true, onDelete: DeleteRule.cascade)
  ImageMetaData imageMetaData;
}
