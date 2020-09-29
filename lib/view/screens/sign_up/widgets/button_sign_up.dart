import 'package:flutter/material.dart';
import 'package:gerente_loja/view/screens/address/address_screen.dart';

class ButtonSaveSignUp extends StatelessWidget {
  final Function _onPressed;
  ButtonSaveSignUp(this._onPressed);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: RaisedButton(
        onPressed: _onPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        color: Theme.of(context).primaryColor,
        splashColor: Colors.grey,
        textColor: Colors.white,
        child: Text('Criar conta comercial'),
      ),
    );
  }
}
