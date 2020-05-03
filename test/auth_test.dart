import 'dart:convert';

import 'harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  /*  test("Register user and retrieve access token", () async {
    var clientID = "com.app.demo";
    var clientSecret = "mySecret";
    var body =
        "username=bob@stablekernel.com&password=foobar&grant_type=password";
    var clientCredentials =
        Base64Encoder().convert("$clientID:$clientSecret".codeUnits);

    var response = await http.post("https://stablekernel.com/auth/token",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "Authorization": "Basic $clientCredentials"
        },
        body: body);
  });
 */
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
}
