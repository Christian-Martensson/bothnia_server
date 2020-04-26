import 'package:bothnia_server/bothnia_server.dart';

class Image extends ManagedObject<_Image> implements _Image {}

class _Image {
  @primaryKey
  int id;

  String name; //e.g. "cropped and saturated"

  String path;

  @Column(nullable: true)
  String resolution;

  int version;

  @Relate(#versions, isRequired: true, onDelete: DeleteRule.cascade)
  ImageMetaData imageMetaData;
}
