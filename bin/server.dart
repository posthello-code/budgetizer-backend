import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

void main() async {
  final handler2 = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(_corsHeaders) // Add CORS headers middleware
      .addHandler(echoRequest);

  final server2 = await io.serve(handler2, InternetAddress.anyIPv4, 4002);
  print(
      'Serving handling requests at http://${server2.address.host}:${server2.port}');
}

Response echoRequest(Request request) {
  if (request.url.path == '/' || request.url.path == '') {
    return Response.ok('Server is up and running');
  } else {
    return Response.notFound('Not found');
  }
}

// CORS headers middleware
Middleware _corsHeaders =
    createMiddleware(responseHandler: (Response response) {
  response = response.change(headers: {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers':
        'Origin, X-Requested-With, Content-Type, Accept'
  });
  return response;
});
