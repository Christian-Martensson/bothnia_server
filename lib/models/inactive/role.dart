/* import 'package:bothnia_server/bothnia_server.dart';

/* enum UserRole {
  admin,
  editor,
  photographer,
  customer,
}
 */
class Role extends ManagedObject<_Role> implements _Role {}

class _Role {
  @primaryKey
  int id;

  String name;

  @Column(defaultValue: "'customer'")
  String role;

  @Relate(#role)
  User user;
}
 */
