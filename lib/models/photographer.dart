import 'package:bothnia_server/bothnia_server.dart';

class Photographer extends ManagedObject<_Photographer>
    implements _Photographer {}

class _Photographer {
  @primaryKey
  int id;

  String fName;

  String lName;

  @Column(unique: true)
  String email;

  ManagedSet<ImageMetaData> images;
}
