import 'package:bothnia_server/bothnia_server.dart';
import 'package:aqueduct_test/aqueduct_test.dart';
import 'package:bothnia_server/model/basic_credential.dart';

export 'package:bothnia_server/bothnia_server.dart';
export 'package:aqueduct_test/aqueduct_test.dart';
export 'package:test/test.dart';
export 'package:aqueduct/aqueduct.dart';
import 'dart:convert';

/// A testing harness for Transformer.
class Harness extends TestHarness<BothniaChannel>
    with TestHarnessAuthMixin<BothniaChannel>, TestHarnessORMMixin {
  @override
  ManagedContext get context => channel.context;

  @override
  AuthServer get authServer => channel.authServer;

  Agent publicAgent;

  Agent adminAgent;
  Agent editorAgent;
  Agent photographerAgent;

  @override
  Future onSetUp() async {
    await resetData();
    // utilityAgent =Got to go now!
    //     await addClient("com.bioservo.biocloud.utility", secret: 'utilitypass');
    // stratusAgent = await addClient("com.bioservo.biocloud.stratus",
    //     allowedScope: allScopes()); // Can not use 'any' here
    // adminAgent = await registerUser(
    //     "admin", "admin", UserType.admin, "admin@bioservo.com",
    //     requestScopes: allScopes());
    // await BasicCredential.insertOrUpdate(
    //     BasicCredential()
    //       ..username = 'public'
    //       ..password = 'hodor99',
    //     context);

    publicAgent =
        await addClient("com.aqueduct.public", allowedScope: allScopes());

    // publicAgent =
    //     await addClient("com.aqueduct.public", allowedScope: allScopes());
    adminAgent = await registerUser("admin", "admin", UserType.admin,
        requestScopes: allScopes());

    // await BasicCredential.insertOrUpdate(
    //     BasicCredential()
    //       ..username = 'admin'
    //       ..password = 'admin',
    //     context);
  }

  Future<Agent> createEditorAgent() async {
    return createAgent("editor", UserType.editor);
  }

  Future<Agent> createPhotographerAgent() async {
    return createAgent("photographer", UserType.photographer);
  }

  Future<Agent> createAgent(
    String usernameAndPassword, [
    UserType type = UserType.customer,
  ]) async {
    Agent ag = await registerUser(
        usernameAndPassword, usernameAndPassword, type,
        requestScopes: allScopes());
    return ag;
  }

  Future<Agent> createExistingAgent(String usernameAndPassword) async {
    return loginUser(publicAgent, usernameAndPassword, usernameAndPassword,
        scopes: allScopes());
  }

  Future<Agent> registerUser(String username, String password, UserType type,
      {List<String> requestScopes}) async {
    final salt = AuthUtility.generateRandomSalt();
    final hashedPassword = authServer.hashPassword(password, salt);
    final user = User()
      ..username = username
      ..type = type
      ..hashedPassword = hashedPassword
      ..salt = salt;
    await Query.insertObject(context, user);
    // adminAgent.headers["authorization"] =
    //     "Basic ${base64.encode("public:hodor99".codeUnits)}";

    return loginUser(publicAgent, username, password, scopes: requestScopes);
  }

  @override
  Future beforeStart() async {
    // add initialization code that will run prior to the test application starting
  }

  @override
  Future afterStart() async {
    // add initialization code that will run once the test application has started
    await resetData();
  }

  @override
  Future seed() async {
    // restore any static data. called afterStart and after resetData
  }

  // Future<TestResponse> makeImageMetadataResponse(Map user) async {
  //   var response = await adminAgent.post("/image", body: {
  //     "extId": "whatever",
  //     "name": "Inst",
  //     "description": "Cool",
  //     "location": "Europe/Stockholm",
  //     "user": {"id": user['id']},
  //     "metadata": {"some": 42}
  //   });
  //   return response;
  // }

  // Future<Map> makeImageMetadata(Map user) async {
  //   return (await makeImageMetadataResponse(user)).body.as<Map>();
  // }

}
