import 'harness/app.dart';
import 'package:http/http.dart' as http;

void main() {
  final harness = Harness()..install();

  tearDown(() async {
    await harness.resetData();
  });

  /*var clientID = "com.app.demo";
    var body =
        "username=bob@stablekernel.com&password=foobar&grant_type=password";
   var clientCredentials = Base64Encoder().convert("$clientID:".codeUnits);

    var response = await http.post("https://stablekernel.com/auth/token",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "Authorization": "Basic $clientCredentials"
        },
        body: body);
  }); */

  test("Can create real user", () async {
    final response = await http.post("http://94.237.24.110:7777/register",
        body: {
          "username": "bob@stablekernel.com",
          "password": "foobaraxegrind12%"
        });

    expect(
        response,
        hasResponse(200,
            body: partial({
              "username": isString,
              "authorization":
                  partial({"access_token": hasLength(greaterThan(0))})
            })));
  });

  test("Can create user", () async {
    final response = await harness.publicAgent.post("/register", body: {
      "username": "bob@stablekernel.com",
      "password": "foobaraxegrind12%"
    });

    expect(
        response,
        hasResponse(200,
            body: partial({
              "username": isString,
              "authorization":
                  partial({"access_token": hasLength(greaterThan(0))})
            })));
  });

  test("Trying to create existing user fails", () async {
    await harness.publicAgent.post("/register", body: {
      "username": "bob@stablekernel.com",
      "password": "someotherpassword"
    });

    final response = await harness.publicAgent.post("/register", body: {
      "username": "bob@stablekernel.com",
      "password": "foobaraxegrind12%"
    });
    expect(response, hasStatus(409));
  });

  test("Omit password fails", () async {
    final response = await harness.publicAgent.post("/register", body: {
      "username": "bobby.bones@stablekernel.com",
    });

    expect(response, hasStatus(400));
  });

  test("Omit username fails", () async {
    final response = await harness.publicAgent
        .post("/register", body: {"username": "foobaraxegrind12%"});

    expect(response, hasStatus(400));
  });
}
