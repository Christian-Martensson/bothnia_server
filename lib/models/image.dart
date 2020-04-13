import 'package:bothnia_server/bothnia_server.dart';

class Image extends ManagedObject<_Image> implements _Image {}

class _Image {
  @Column(primaryKey: true)
  int id;

  @Column()
  String name;
}
