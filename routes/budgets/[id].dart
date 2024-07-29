import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  final db = context.read<Db>();
  final method = context.request.method.toString();
  final collection = db.collection('budgets');
  final oid = ObjectId.fromHexString(id);
  if (method == 'HttpMethod.get') {
    final r = await collection.findOne({'_id': oid});
    return Response(body: jsonEncode(r));
  }
  if (method == 'HttpMethod.put') {
    final body = await context.request.body();
    final json = jsonDecode(body) as Map<String, dynamic>;
    json.remove('id');
    await collection.replaceOne({'_id': oid}, json);
    return Response(body: jsonEncode(json));
  }
  return Response(statusCode: 405);
}
