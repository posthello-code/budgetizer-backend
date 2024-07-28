import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) {
  return (context) async {
    // do something before
    final response = await handler(context);
    // do something after
    return response;
  };
}
