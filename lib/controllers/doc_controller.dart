import '../bothnia_server.dart';

class DocController extends ResourceController {
  DocController(this.context);
  ManagedContext context;

  @Operation.get()
  Future<Response> getDoc() async {
    final file = File("web/client.html");

    var response = Response.ok(file.readAsStringSync());
    //..contentType = ContentType("application", "html");

    return response;
  }
}
