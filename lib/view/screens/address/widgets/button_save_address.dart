import 'package:flutter/material.dart';
import 'package:gerente_loja/view/screens/home/home_screen.dart';

class ButtonSaveAddress extends StatelessWidget {
  final Function _save;
  ButtonSaveAddress(this._save);
  @override
  Widget build(BuildContext context) {
    void _onpressed() async {
      String error = await _save();
      error.isNotEmpty
          ? Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
                error,
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.redAccent,
            ))
          : Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ));
    }

    return SizedBox(
      height: 50,
      child: RaisedButton(
        onPressed: _onpressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        color: Theme.of(context).primaryColor,
        splashColor: Colors.grey,
        textColor: Colors.white,
        child: Text('Salvar Dados e Conluir'),
      ),
    );
  }
}
