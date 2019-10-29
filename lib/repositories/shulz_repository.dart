import 'dart:async';
import 'package:meta/meta.dart';
import 'package:shulz/utils/http_client.dart';
import 'package:shulz/api_routes/api_routes.dart';

class ShulzRepository {
  final HttpClient httpClient;

  ShulzRepository({@required this.httpClient});

  Future<void> getList() async {
    return await httpClient.get(ShulzRoutes.getList);
  }
}
