import 'bothnia_server.dart';
import 'controllers/doc_controller.dart';
import 'controllers/image_controller.dart';
import 'controllers/upload_controller.dart';

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

    final authStorage = ManagedAuthDelegate<User>(context);
    authServer = AuthServer(authStorage);
  }

  @override
  Controller get entryPoint {
    final router = Router();

    router.route("/example").linkFunction((request) async {
      return Response.ok({"key": "value"});
    });

    // OAUTH stuff
    // Set up auth token route- this grants and refresh tokens
    router.route("/auth/token").link(() => AuthController(authServer));

    // Set up auth code route- this grants temporary access codes that can be exchanged for token
    router.route("/auth/code").link(() => AuthCodeController(authServer));

    // Set up protected route
    router
        .route("/protected")
        .link(() => Authorizer.bearer(authServer))
        .linkFunction((request) async {
      return Response.ok({"key": "value"});
    });

    // IMAGES
    router.route("/image/original").link(() => ImageController(context));

    //router.route("/category/[:id]").link(() => CategoryController(context));

    //router.route("/image/[:id]").link(() => ImageController(context));

    // for accessing a file, e.g. "ip/files/test.jpg"
    router.route("/files/*").link(() => FileController("public/"));

    // for uploading images using base64Encoded in json.
    router.route("/upload").link(() => UploadController(context));

    // for serving the API docs
    router.route("/doc").link(() => DocController(context));

    // /

    return router;
  }
}

class MyConfig extends Configuration {
  MyConfig(String path) : super.fromFile(File(path));

  DatabaseConfiguration database;
}
