import 'package:bothnia_server/controllers/photographer_controller.dart';
import 'package:bothnia_server/controllers/tag_controller.dart';
import 'package:bothnia_server/service/basic_credential_verifier.dart';

import 'bothnia_server.dart';
import 'controllers/doc_controller.dart';
import 'controllers/image_controller.dart';
import 'controllers/upload_controller.dart';
import 'controllers/user_controller.dart';

/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://aqueduct.io/docs/http/channel/.
class BothniaChannel extends ApplicationChannel {
  ManagedContext context;
  AuthServer authServer;
  BasicCredentialVerifier basicCredentialVerifier;

  @override
  Future prepare() async {
    final config = BothniaConfiguration(options.configurationFilePath);
    context = contextWithConnectionInfo(config.database);

    final authStorage = ManagedAuthDelegate<User>(context);
    authServer = AuthServer(authStorage);
    basicCredentialVerifier = BasicCredentialVerifier(context);
  }

  @override
  Controller get entryPoint {
    final router = Router();

    router
        .route("/photographer/[:id]")
        .link(() => PhotographerController(context));

    router.route("/tag/[:id]").link(() => TagController(context));

    router.route("/example").linkFunction((request) async {
      return Response.ok({"key": "value"});
    });

    router.route("/example2").linkFunction((request) async {
      return Response.ok({"key": "value"});
    });

    /* OAuth 2.0 Endpoints */

    // Set up auth token route- this grants and refresh tokens
    router.route("/auth/token").link(() => AuthController(authServer));

    // Set up auth code route- this grants temporary access codes that can be exchanged for token
    //router.route("/auth/code").link(() => AuthRedirectController(authServer));

    router
      ..route("/user/[:username]")
          //  .link(() => Authorizer.bearer(authServer, scopes: ["admin"]))
          .linkFunction((request) async {
        return Response.ok({"key": "value"});
      }).link(() => UserController(context, authServer));

    // Set up protected route
    router
        .route("/protected")
        .link(() => Authorizer.bearer(authServer))
        .linkFunction((request) async {
      return Response.ok({"secret": "secret"});
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

class BothniaConfiguration extends Configuration {
  BothniaConfiguration(String path) : super.fromFile(File(path));

  DatabaseConfiguration database;

  /// This property is required.
  //String host;
}

/// Return all possible scopes
List<String> allScopes() {
  List<String> scopes = [];
  for (UserType type in UserType.values) {
    scopes.add(type.toString().split('.').last);
  }
  scopes.add("canEditor");
  scopes.add("canPhotographer");

  print("Scopes: $scopes");
  return scopes;
}

/// This class defines our rules for which users have what scopes. For the moment
/// "admin" is the only user with all scopes.
class TransformerAuthDelegate extends ManagedAuthDelegate<User> {
  TransformerAuthDelegate(ManagedContext context, {int tokenLimit: 40})
      : super(context, tokenLimit: tokenLimit);

  @override

  /// We override in order to also pull up type, canBioservo, canInstallation, canSuperUser
  Future<User> getResourceOwner(AuthServer server, String username) {
    final query = Query<User>(context)
      ..where((u) => u.username).equalTo(username)
      ..returningProperties((t) => [
            t.id,
            t.username,
            t.hashedPassword,
            t.salt,
            t.type,
            t.canEditor,
          ]);
    return query.fetchOne();
  }

  static String typeToString(UserType type) {
    return type.toString().split(".").last;
  }

  @override

  /// The possible List of scopes is the [UserType] and the canXXX permission flags.
  /// The controllers then further use combinations of scopes to decide if the operation is allowed.
  List<AuthScope> getAllowedScopes(covariant User user) {
    var scopes = <AuthScope>[];
    // Add one scope matching the UserType
    scopes.add(AuthScope(typeToString(user.type)));
    // Add further scopes based on UserType and permission flags
    switch (user.type) {
      case UserType.admin:
        // Shortcut, admin match all scopes
        return AuthScope.any;
      case UserType.editor:
        scopes.add(AuthScope(typeToString(UserType.editor)));
        if (user.canEditor) {
          scopes.add(AuthScope("canEditor"));
        }
        if (user.canPhotographer) {
          scopes.add(AuthScope("canPhotographer"));
        }
        break;

      case UserType.photographer:
        scopes.add(AuthScope(typeToString(UserType.photographer)));
        if (user.canPhotographer) {
          scopes.add(AuthScope("canPhotographer"));
        }
        break;
      case UserType.customer:
        break;
    }
    print("Scopes: $scopes");
    return scopes;
  }
}
