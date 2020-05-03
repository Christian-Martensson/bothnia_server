import 'dart:convert';

import 'harness/app.dart';
import 'package:http/http.dart' as http;

Future main() async {
  final harness = Harness()..install();

  test("Can create real user", () async {
    final response = await http.post("http://94.237.24.110:7777/register",
        body: {"username": "bothnia", "password": "bothnia"});

    expect(
        response,
        hasResponse(200,
            body: partial({
              "username": isString,
              "authorization":
                  partial({"access_token": hasLength(greaterThan(0))})
            })));
  });
  test("Register user and retrieve access token", () async {
    const clientID = "com.bothnia.web";
    const body = "username=bothnia&password=bothnia&grant_type=password";
    final clientCredentials = Base64Encoder().convert("$clientID:".codeUnits);

    var response = await http.post("http://94.237.24.110:7777/auth/token",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "Authorization": "Basic $clientCredentials"
        },
        body: body);

    print(response);
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
}
