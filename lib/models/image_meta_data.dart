import 'package:bothnia_server/bothnia_server.dart';

class ImageMetaData extends ManagedObject<_ImageMetaData>
    implements _ImageMetaData {}

class _ImageMetaData {
  @Column(primaryKey: true)
  int id;

  String name;

  @Column(nullable: true)
  String description;

  DateTime created;

  @Column(nullable: true)
  DateTime firstPubDate;

  @Column(nullable: true)
  String coordinates;

  @Column(nullable: true)
  String license;

  @Column(nullable: true)
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
