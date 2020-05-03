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
class BothniaChannel extends ApplicationChannel
    implements AuthRedirectControllerDelegate {
  final HTMLRenderer htmlRenderer = HTMLRenderer();
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

    // OAUTH stuff
    /* OAuth 2.0 Endpoints */
    router.route("/auth/token").link(() => AuthController(authServer));

    router
        .route("/auth/form")
        .link(() => AuthRedirectController(authServer, delegate: this));

    /* Create an account */
    router
        .route("/register")
        .link(() => Authorizer.basic(authServer))
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

    // /

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

  @override
  Future<String> render(AuthRedirectController forController, Uri requestUri,
      String responseType, String clientID, String state, String scope) async {
    final map = {
      "response_type": responseType,
      "client_id": clientID,
      "state": state
    };

    map["path"] = requestUri.path;
    if (scope != null) {
      map["scope"] = scope;
    }

    return htmlRenderer.renderHTML("web/login.html", map);
  }
}

class MyConfig extends Configuration {
  MyConfig(String path) : super.fromFile(File(path));

  DatabaseConfiguration database;
}
