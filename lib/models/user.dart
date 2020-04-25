import 'package:bothnia_server/bothnia_server.dart';

/* class User extends ManagedObject<_User> implements _User {}

class _User {
  @Column(primaryKey: true)
  int id;

  @Column(unique: true)
  String username;

  String password;

  ManagedSet<ImageMetaData> images;
} */

class User extends ManagedObject<_User>
    implements _User, ManagedAuthResourceOwner<_User> {
  @Serialize(input: true, output: false)
  String password;
}

class _User extends ResourceOwnerTableDefinition {
  ManagedSet<ImageMetaData> images;

/* This class inherits the following from ManagedAuthenticatable:

  @primaryKey
  int id;

  @Column(unique: true, indexed: true)
  String username;

  @Column(omitByDefault: true)
  String hashedPassword;

  @Column(omitByDefault: true)
  String salt;

  ManagedSet<ManagedAuthToken> tokens;
 */
}
