import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';

Future<Response> onRequest(RequestContext context) async {
  final db = context.read<Db>();
  final collection = db.collection('budgets');
  final body = await context.request.body();
  final json = jsonDecode(body) as Map<String, dynamic>;

  // Handle updates
  if (json.keys.any((key) => key == 'id') &&
      context.request.method.toString() == 'HttpMethod.post') {
    final existingOid = ObjectId.fromHexString(json['id'] as String);
    json.remove('id');
    await collection.replaceOne({'_id': existingOid}, json);
    return Response(body: jsonEncode(json));
  }

  // Handle creates
  if (context.request.method.toString() == 'HttpMethod.post') {
    await collection.insertOne(json);
    return Response(body: jsonEncode(json));
  }

  return Response(statusCode: 405);
}
