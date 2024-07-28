import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dotenv/dotenv.dart';
import 'package:mongo_dart/mongo_dart.dart';

DotEnv env = DotEnv(includePlatformEnvironment: true)..load();

Future<Db> initDb() async {
  final db = await Db.create(
    'mongodb+srv://mongodb:${env['MONGODB_PW']}@budgetizer.yere7rm.mongodb.net/budgetizer',
  );

  // ignore: avoid_print
  print('Initialized database');
  await db.open();
  return db;
}

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) async {
  final db = await initDb();
  return serve(handler.use(provider<Db>((context) => db)), ip, port);
}
