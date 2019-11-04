import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback _onPressed;

  LoginButton({Key key, VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: _onPressed,
      child: Text(
        'Shulz\nup',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontFamily: 'Limelight',
        ),
      ),
      shape: CircleBorder(),
      elevation: 3.0,
      fillColor: Colors.white,
      padding: EdgeInsets.all(25.0),
    );
  }
}
