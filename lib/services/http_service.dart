import 'package:dio/dio.dart';

class HTTPService {
  HTTPService();
  final _dio = Dio();

  Future<Response?> get(String path) async {
    try {
      Response res = await _dio.get(path);
      return res;
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    return null;
  }
}
