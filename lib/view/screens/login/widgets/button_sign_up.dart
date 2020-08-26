import 'package:flutter/material.dart';
import 'package:gerente_loja/view/screens/sign_up/sign_up_screen.dart';

class ButtonSignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Não tem cadastro ainda?'),
        FlatButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SignUpScreen(),
              ));
            },
            child: Text(
              'Crie um conta',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            ))
      ],
    );
  }
}
