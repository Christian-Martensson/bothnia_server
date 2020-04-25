import 'package:bothnia_server/bothnia_server.dart';

class ImageMetaData extends ManagedObject<_ImageMetaData>
    implements _ImageMetaData {}

class _ImageMetaData {
  @Column(primaryKey: true)
  int id;

  String name;

  String description;

  DateTime created;

  DateTime firstPubDate;

  String coordinates;

  String license;

  int usesLeft;

  bool isPublicallyAdded;

  ManagedSet<Image> versions;

  ManagedSet<ImageToTag> imageTags;

  @Relate(#images)
  Category category;

  @Relate(#images)
  Photographer photographer;

  @Relate(#images)
  User user;
}
