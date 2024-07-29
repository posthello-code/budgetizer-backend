import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';

Future<Response> onRequest(RequestContext context) async {
  final db = context.read<Db>();
  final collection = db.collection('budgets');
  final body = await context.request.body();
  final method = context.request.method.toString();
  try {
    if (method != 'HttpMethod.post') {
      return Response(statusCode: 405);
    }
    final json = jsonDecode(body) as Map<String, dynamic>;

    // Handle updates
    if (json.keys.any((key) => key == 'id')) {
      final existingOid = ObjectId.fromHexString(json['id'] as String);
      json.remove('id');
      await collection.replaceOne({'_id': existingOid}, json);
      return Response(body: jsonEncode(json));
    }

    // Handle creates
    await collection.insertOne(json);
    return Response(body: jsonEncode(json));
  } catch (e) {
    return Response(statusCode: 500, body: e.toString());
  }
}
