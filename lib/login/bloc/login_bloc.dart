import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shulz/login/bloc/bloc.dart';
import 'package:shulz/repositories/user_repository.dart';
import 'package:shulz/utils/validators.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;

  LoginBloc({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  LoginState get initialState => LoginState.empty();

  @override
  Stream<LoginState> transformEvents(
    Stream<LoginEvent> events,
    Stream<LoginState> Function(LoginEvent event) next,
  ) {
    final observableStream = events as Observable<LoginEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! UsernameChanged && event is! PasswordChanged);
    });
    final debounceStream = observableStream.where((event) {
      return (event is UsernameChanged || event is PasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super
        .transformEvents(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is UsernameChanged) {
      yield* _mapUsernameChangedToState(event.username);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is LoginPressed) {
      yield* _mapLoginPressedToState(
        username: event.username,
        password: event.password,
      );
    }
  }

  Stream<LoginState> _mapUsernameChangedToState(String username) async* {
    yield state.update(
      isUsernameValid: Validators.isValidUsername(username),
    );
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<LoginState> _mapLoginPressedToState({
    String username,
    String password,
  }) async* {
    yield LoginState.loading();
    try {
      await _userRepository.signIn(
          password: password, username: username, pushToken: 'push token');
      yield LoginState.success();
    } catch (_) {
      yield LoginState.failure();
    }
  }
}
