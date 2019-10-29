import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static final String apiHost = DotEnv().env['API_HOST'];
}
