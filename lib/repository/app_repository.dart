import 'package:flutter_game/network/api_client.dart';

class AppRepository {
  Future<dynamic> login(dynamic body) async {
    try {
      final response = await ApiClient.instance.post("/auth/login", body);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }
}