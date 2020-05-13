import '../bothnia_server.dart';

class DocController extends ResourceController {
  DocController(this.context);
  ManagedContext context;

  @Operation.get()
  Future<Response> getDoc() async {
    final file = File("web/client.html");

    return Response.ok(file.readAsStringSync())
      ..contentType = ContentType.html; //ContentType("application", "html");
  }
}
