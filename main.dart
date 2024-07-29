import 'dart:io';
import 'dart:typed_data';

import 'package:dart_frog/dart_frog.dart';
import 'package:dotenv/dotenv.dart';
import 'package:mongo_dart/mongo_dart.dart';

Future<Db> initDb() async {
  String? mongodbPw;

  if (File('.env').existsSync()) {
    final env = DotEnv(includePlatformEnvironment: true, quiet: true)..load();
    mongodbPw = env['MONGODB_PW'];
  } else {
    mongodbPw = Platform.environment['MONGODB_PW'];
  }

  final db = await Db.create(
    'mongodb+srv://mongodb:$mongodbPw@budgetizer.yere7rm.mongodb.net/budgetizer',
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
