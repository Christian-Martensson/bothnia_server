import 'package:bothnia_server/controllers/register_controller.dart';

import 'bothnia_server.dart';
import 'controllers/doc_controller.dart';
import 'controllers/identity_controller.dart';
import 'controllers/image_controller.dart';
import 'controllers/upload_controller.dart';
import 'controllers/user_controller.dart';
import 'utility/html_template.dart';

/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://aqueduct.io/docs/http/channel/.
class BothniaChannel extends ApplicationChannel {
  ManagedContext context;
  AuthServer authServer;

  @override
  Future prepare() async {
    final config = MyConfig(options.configurationFilePath);
    context = contextWithConnectionInfo(config.database);

    final authStorage = ManagedAuthDelegate<User>(context);
    authServer = AuthServer(authStorage);
  }

  @override
  Controller get entryPoint {
    final router = Router();

    router.route("/example").linkFunction((request) async {
      return Response.ok({"key": "value"});
    });

    /* OAuth 2.0 Endpoints */

    // Set up auth token route- this grants and refresh tokens
    router.route("/auth/token").link(() => AuthController(authServer));

    // Set up auth code route- this grants temporary access codes that can be exchanged for token
    router.route("/auth/code").link(() => AuthRedirectController(authServer));

    // Set up protected route
    router
        .route("/protected")
        .link(() => Authorizer.bearer(authServer))
        .linkFunction((request) async {
      return Response.ok({"secret": "secret"});
    });

    /* Create an account */
    router
        .route("/register")
        //  .link(() => Authorizer.basic(authServer))
        .link(() => RegisterController(context, authServer));

    /* Gets profile for user with bearer token */
    router
        .route("/me")
        .link(() => Authorizer.bearer(authServer))
        .link(() => IdentityController(context));

    /* Gets all users or one specific user by id */
    router
        .route("/users/[:id]")
        .link(() => Authorizer.bearer(authServer))
        .link(() => UserController(context, authServer));

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
    return router;
  }

  ManagedContext contextWithConnectionInfo(
      DatabaseConfiguration connectionInfo) {
    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final psc = PostgreSQLPersistentStore(
        connectionInfo.username,
        connectionInfo.password,
        connectionInfo.host,
        connectionInfo.port,
        connectionInfo.databaseName);

    return ManagedContext(dataModel, psc);
  }
}

class MyConfig extends Configuration {
  MyConfig(String path) : super.fromFile(File(path));

  DatabaseConfiguration database;
}
