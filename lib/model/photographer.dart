import 'package:bothnia_server/bothnia_server.dart';

class Photographer extends ManagedObject<_Photographer>
    implements _Photographer {}

class _Photographer {
  @primaryKey
  int id;

  String fName;

  String lName;

  @Column(nullable: true)
  String email;

  @Column(nullable: true)
  String phone;

  ManagedSet<ImageMetaData> images;
}
