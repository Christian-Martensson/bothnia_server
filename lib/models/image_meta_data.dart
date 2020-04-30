import 'package:bothnia_server/bothnia_server.dart';

class ImageMetaData extends ManagedObject<_ImageMetaData>
    implements _ImageMetaData {
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

class _ImageMetaData {
  @primaryKey
  int id;

  String name;

  @Column(nullable: true)
  String description;

  DateTime created;

  DateTime modified;

  // nullable in case EXIF is missing
  @Column(nullable: true)
  DateTime captured;

  @Column(nullable: true)
  DateTime firstPubDate;

  @Column(nullable: true)
  String coordinates;

  @Column(nullable: true)
  String license;

  @Column(nullable: true)
  int usesLeft;

  @Column(defaultValue: "false")
  bool isPublicallyAdded;

  ManagedSet<Image> versions;

  ManagedSet<ImageToTag> imageTags;

/*   @Relate(#images, isRequired: true, onDelete: DeleteRule.restrict)
  Category category; */

  @Relate(#images)
  Photographer photographer;

  @Relate(#images)
  User user;
}
