import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  final db = context.read<Db>();

  Future<Map<String, dynamic>?> getById(String id) {
    return db
        .collection('budgets')
        .findOne({'_id': ObjectId.fromHexString(id)});
  }

  if (context.request.method.toString() == 'HttpMethod.get') {
    final r = await getById(id);
    return Response(body: jsonEncode(r));
  }
  if (context.request.method.toString() == 'HttpMethod.put') {
    final body = await context.request.body();
    final json = jsonDecode(body) as Map<String, dynamic>;
    // ignore: cascade_invocations
    json.remove('id');
    await db
        .collection('budgets')
        .replaceOne({'_id': ObjectId.fromHexString(id)}, json);
    return Response(body: jsonEncode(json));
  }
  return Response(statusCode: 405);
}
