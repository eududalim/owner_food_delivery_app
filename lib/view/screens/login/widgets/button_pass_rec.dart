import 'package:flutter/material.dart';

class ButtonPasswordRecover extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: FlatButton(
          padding: EdgeInsets.zero,
          onPressed: () {},
          textColor: Colors.black54,
          child: Text('Esqueceu a senha?',
              style: TextStyle(fontWeight: FontWeight.bold))),
    );
  }
}
