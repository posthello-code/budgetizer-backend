import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';

Future<Response> onRequest(RequestContext context) async {
  final db = context.read<Db>();

  if (context.request.method.toString() == 'HttpMethod.post') {
    final body = await context.request.body();
    final json = jsonDecode(body) as Map<String, dynamic>;
    json.remove('id');
    await db.collection('budgets').insertOne(json);
    return Response(body: jsonEncode(json));
  }
  return Response(statusCode: 405);
}
