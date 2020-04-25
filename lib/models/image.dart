import 'package:bothnia_server/bothnia_server.dart';

class Image extends ManagedObject<_Image> implements _Image {}

class _Image {
  @primaryKey
  int id;

  String name; //e.g. "cropped and saturated"

  String path;

  @Column(nullable: true)
  String resolution;

  double version; // 0 for original, the rest customisable. 1.1, 1.2, 2.1 etc.

  @Relate(#versions)
  ImageMetaData imageMetaData;
}
