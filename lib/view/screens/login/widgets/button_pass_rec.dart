import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonPasswordRecover extends StatelessWidget {
  final Function _recoveryPassword;
  ButtonPasswordRecover(this._recoveryPassword);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: FlatButton(
          padding: EdgeInsets.zero,
          onPressed: () async {
            String error = await _recoveryPassword();
            error == null
                ? showDialog(
                    context: context,
                    child: CupertinoAlertDialog(
                      title: Text('Esqueceu sua senha?'),
                      content: Text(
                          'Instruções para recuperar sua senha foram enviadas' +
                              ' para o email informado. \nVerique sua caixa de mensagens.'),
                      actions: [
                        FlatButton(
                            onPressed: () => Navigator.pop(context),
                            textColor: Theme.of(context).primaryColor,
                            child: Text('OK'))
                      ],
                    ))
                : Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(
                      error.toString(),
                      textAlign: TextAlign.center,
                    ),
                    backgroundColor: Colors.redAccent,
                  ));
          },
          textColor: Colors.black54,
          child: Text('Esqueceu a senha?',
              style: TextStyle(fontWeight: FontWeight.bold))),
    );
  }
}
