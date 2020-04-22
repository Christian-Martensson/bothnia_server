import 'package:bothnia_server/bothnia_server.dart';

class Image extends ManagedObject<_Image> implements _Image {}

class _Image {
  @Column(primaryKey: true)
  int id;

  String name;

  String path;

  double version;

  String resolution;

  @Relate(#versions)
  ImageMetaData metaData;
}
