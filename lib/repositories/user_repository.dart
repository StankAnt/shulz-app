import 'dart:async';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shulz/api_routes/api_routes.dart';

class UserRepository {
  final Dio httpClient;
  final FlutterSecureStorage storage;

  UserRepository({@required this.httpClient, @required this.storage});

  Future<void> signIn({
    @required String username,
    @required String password,
    @required String pushToken,
  }) async {
    final body = {
      "name": username,
      "password": password,
      "pushToken": pushToken,
    };
    try {
      return await httpClient.post(
        UserRoutes.signUp,
        data: body,
      );
    } catch (_) {
      return await httpClient.post(
        UserRoutes.signIn,
        data: body,
      );
    }
  }

  Future<void> persistUser(
      {@required String username, @required String token}) async {
    await storage.write(key: 'username', value: username);
    await storage.write(key: 'token', value: token);
    return;
  }

  Future<bool> isSignedIn() async {
    final token = await storage.read(key: 'token');
    return token != null;
  }

  Future<String> getUserName() async {
    return await storage.read(key: 'username');
  }

  Future<String> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<void> signOut() async {
    return await storage.deleteAll();
  }
}
