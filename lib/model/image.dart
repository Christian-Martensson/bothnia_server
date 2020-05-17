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

  String name;

  @Column(nullable: true)
  String description;

  DateTime created;

  DateTime modified;

  @Column(nullable: true)
  DateTime firstPubDate;

  @Column(nullable: true)
  String gpsLatitude;

  @Column(nullable: true)
  String gpsLongitude;

  @Column(nullable: true)
  String location;

  @Column(nullable: true)
  String cameraModel;

  @Column(nullable: true)
  String imageWidth;

  @Column(nullable: true)
  String imageHeight;

  @Column(nullable: true)
  DateTime captured;

  @Column(nullable: true)
  String license;

  @Column(nullable: true)
  int usesLeft;

  @Column(nullable: true)
  String resolution;

  @Column(defaultValue: "false")
  bool isPublicallyAdded;

  ManagedSet<ImageToTag> imageTags;

  @Relate(#images)
  Photographer photographer;

  @Relate(#images)
  User user;
}
