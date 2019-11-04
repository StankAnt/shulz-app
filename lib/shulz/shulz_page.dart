import 'package:flutter/material.dart';
import 'package:shulz/screens_routes.dart';

class ShulzPage extends StatelessWidget {
  ShulzPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shulz')),
      body: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        onPressed: () => _onPressed(context),
        child: Text('To Login'),
      ),
    );
  }

  void _onPressed(context) {
    Navigator.pushNamed(context, ScreensRoutes.some);
  }
}
