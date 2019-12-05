import 'dart:async';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:shulz/api_routes/api_routes.dart';

class ShulzRepository {
  final Dio httpClient;

  ShulzRepository({@required this.httpClient});

  Future<void> getList() async {
    return await httpClient.get(ShulzRoutes.getList);
  }
}
