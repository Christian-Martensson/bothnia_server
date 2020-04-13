import 'package:bothnia_server/controllers/image_controller.dart';

import 'bothnia_server.dart';

/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://aqueduct.io/docs/http/channel/.
class BothniaServerChannel extends ApplicationChannel {
  ManagedContext context;

  AuthServer authServer;

  @override
  Future prepare() async {
    final config = MyConfig(options.configurationFilePath);
    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final store = PostgreSQLPersistentStore.fromConnectionInfo(
        config.database.username,
        config.database.password,
        config.database.host,
        config.database.port,
        config.database.databaseName);
    context = ManagedContext(dataModel, store);

    /*  final authStorage = ManagedAuthDelegate<User>(context);
    authServer = AuthServer(authStorage); */
  }

  @override
  Controller get entryPoint {
    final router = Router();

    router.route("/example").linkFunction((request) async {
      return Response.ok({"key": "value"});
    });

    router.route("/image/[:id]").link(() => ImageController(context));

    return router;
  }
}

class MyConfig extends Configuration {
  MyConfig(String path) : super.fromFile(File(path));

  DatabaseConfiguration database;
}
