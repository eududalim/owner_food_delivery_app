import 'package:flutter/material.dart';
import 'package:gerente_loja/view/screens/address/address_screen.dart';

class ButtonSaveSignUp extends StatelessWidget {
  final Function _signUp;
  ButtonSaveSignUp(this._signUp);
  @override
  Widget build(BuildContext context) {
    void _onpressed() async {
      String error = await _signUp();
      error.isNotEmpty
          ? Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
                error,
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.redAccent,
            ))
          : Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddressScreen(),
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
        child: Text('Criar conta comercial'),
      ),
    );
  }
}
