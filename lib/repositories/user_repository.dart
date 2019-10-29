import 'dart:async';
import 'package:meta/meta.dart';
import 'package:shulz/utils/http_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shulz/api_routes/api_routes.dart';

class UserRepository {
  final HttpClient httpClient;
  final FlutterSecureStorage storage;

  UserRepository({@required this.httpClient, @required this.storage});

  Future<void> signUp({
    @required String username,
    @required String password,
    @required String pushToken,
  }) async {
    return await httpClient.post(UserRoutes.signUp);
  }

  Future<void> signIn({
    @required String username,
    @required String password,
    @required String pushToken,
  }) async {
    return await httpClient.post(UserRoutes.signIn);
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
