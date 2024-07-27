import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context, String id) {
  if (context.request.method.toString() == 'HttpMethod.get') {
    return Response(body: jsonEncode({'data': 'get response'}));
  }
  if (context.request.method.toString() == 'HttpMethod.put') {
    return Response(body: jsonEncode({'data': 'put response'}));
  }
  return Response(statusCode: 405);
}
