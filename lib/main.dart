import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shulz/authentication/authentication.dart';
import 'package:shulz/bloc/bloc.dart';
import 'package:shulz/config.dart';
import 'package:shulz/repositories/user_repository.dart';
import 'package:shulz/router/router.dart';
import 'package:shulz/shulz/shulz.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();

  await DotEnv().load('.env');

  final Dio _dio = new Dio();

  _dio.options.baseUrl = Config.apiHost;
  _dio.options.connectTimeout = 5000;
  _dio.options.receiveTimeout = 3000;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  final UserRepository userRepository =
      UserRepository(httpClient: _dio, storage: secureStorage);

  runApp(
    BlocProvider(
      builder: (context) =>
          AuthenticationBloc(userRepository: userRepository)..add(AppStarted()),
      child: App(userRepository: userRepository),
    ),
  );
}

class App extends StatelessWidget {
  final UserRepository _userRepository;

  App({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Uninitialized) {
            return ShulzPage();
          }
          return Router(
            isAuthenticated: state is Authenticated,
            userRepository: _userRepository,
          ).buildNavigator();
        },
      ),
    );
  }
}
