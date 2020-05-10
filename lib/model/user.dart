import 'package:bothnia_server/bothnia_server.dart';

enum UserType {
  admin,
  editor,
  photographer,
  customer,
}

class User extends ManagedObject<_User>
    implements _User, ManagedAuthResourceOwner<_User> {
  @Serialize(input: true, output: false)
  String password;

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

class _User extends ResourceOwnerTableDefinition {
  DateTime created;
  DateTime modified;

  @Column(defaultValue: "'customer'")
  UserType type;

  ManagedSet<Image> images; //images uploaded by user

  @Column(defaultValue: "false")
  bool canEditor = false;

  @Column(defaultValue: "false")
  bool canPhotographer = false;

  @Column(defaultValue: "''")
  String name;
  /* 
  This class inherits the following from ManagedAuthenticatable:

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
