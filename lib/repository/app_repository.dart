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


  Future<dynamic> register(dynamic body) async {
    try {
      final response = await ApiClient.instance.post("/auth/register", body);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> verifyOtp(dynamic body) async {
    try {
      final response = await ApiClient.instance.post("/auth/otp-verify", body);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> addUser(dynamic body) async {
    try {
      final response = await ApiClient.instance.post("/auth/add-user", body);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> updateUser(dynamic body) async {
    try {
      final response = await ApiClient.instance.put("/auth/update-user", body);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getUser() async {
    try {
      final response = await ApiClient.instance.get("/auth/user/me");
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getRank(String? userId, String score, {Function(int, int)? onReceiveProgress}) async {
    try {
      final response = await ApiClient.instance.get("/ranking/user/$userId/score/$score", onReceiveProgress: onReceiveProgress);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }
}