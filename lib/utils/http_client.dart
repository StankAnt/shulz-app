import 'package:http/http.dart' as http;
import 'package:shulz/config.dart';

class HttpClient extends http.BaseClient {
  final _client = new http.Client();
  final String _host = Config.apiHost;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    final path = Uri.parse('$_host${request.url}');
    http.Request req = new http.Request(request.method, path);

    return _client.send(req);
  }
}
