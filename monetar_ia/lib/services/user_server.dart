import 'request_http.dart';
import 'package:http/http.dart' as http;

class UserService {
  final RequestHttp _requestHttp = RequestHttp();

  Future<http.Response> getUserData(String userId) async {
    final response = await _requestHttp.get('users/$userId');
    return response;
  }

  Future<http.Response> updateUserProfile(
      String userId, Map<String, dynamic> data) async {
    final response = await _requestHttp.put('users/$userId', data);
    return response;
  }
}
