#!/usr/bin/env dart
import 'package:bothnia_server/bothnia_server.dart';

Future main() async {
  var app = new Application<BothniaServerChannel>()
      ..options.configurationFilePath = "config.yaml"
      ..options.port = 7777;

  await app.start(numberOfInstances: Platform.numberOfProcessors);

  print("Application started on port: ${app.options.port}.");
  print("Use Ctrl-C (SIGINT) to stop running the application.");
}