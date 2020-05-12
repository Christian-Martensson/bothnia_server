import 'package:bothnia_server/bothnia_server.dart';

class Photographer extends ManagedObject<_Photographer>
    implements _Photographer {}

class _Photographer {
  @primaryKey
  int id;

  String name;

  @Column(nullable: true)
  String email;

  @Column(nullable: true)
  String phone;

  ManagedSet<Image> images;
}
