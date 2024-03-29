import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shulz/repositories/user_repository.dart';
import 'package:shulz/authentication/authentication.dart';
import 'package:shulz/login/login.dart';

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;

  LoginForm({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _usernameController.addListener(_onUsernameChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  bool get isPopulated =>
      _usernameController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        print(state);
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.only(
              left: 50,
              right: 50,
            ),
            child: Form(
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: 'Login',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey[500],
                            width: 2,
                          ),
                        ),
                      ),
                      textAlign: TextAlign.center,
                      autovalidate: true,
                      autocorrect: false,
                      validator: (_) {
                        return !state.isUsernameValid
                            ? 'Invalid Username'
                            : null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey[500],
                            width: 2,
                          ),
                        ),
                      ),
                      textAlign: TextAlign.center,
                      obscureText: true,
                      autovalidate: true,
                      autocorrect: false,
                      validator: (_) {
                        return !state.isPasswordValid
                            ? 'Invalid Password'
                            : null;
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          LoginButton(
                            onPressed: isLoginButtonEnabled(state)
                                ? _onFormSubmitted
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onUsernameChanged() {
    _loginBloc.add(
      UsernameChanged(
        username: _usernameController.text,
      ),
    );
  }

  void _onPasswordChanged() {
    _loginBloc.add(
      PasswordChanged(
        password: _passwordController.text,
      ),
    );
  }

  void _onFormSubmitted() {
    _loginBloc.add(
      LoginPressed(
        username: _usernameController.text,
        password: _passwordController.text,
      ),
    );
  }
}
