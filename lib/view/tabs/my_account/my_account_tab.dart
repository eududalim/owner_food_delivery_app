import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/login_bloc.dart';

import 'package:gerente_loja/models/user_admin_model.dart';
import 'package:gerente_loja/view/tabs/my_account/widgets/tile_account.dart';

class MyAccountTab extends StatefulWidget {
  final UserAdminModel user;

  MyAccountTab(
    this.user,
  );

  @override
  _MyAccountTabState createState() => _MyAccountTabState(user);
}

class _MyAccountTabState extends State<MyAccountTab> {
  final UserAdminModel _user;
  final LoginBloc _loginBloc = LoginBloc();

  _MyAccountTabState(this._user);

  @override
  Widget build(BuildContext context) {
    return ListView(padding: EdgeInsets.all(18), children: [
      Text(
        'MINHA CONTA',
        style: TextStyle(
            fontSize: 25,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w600),
      ),
      SizedBox(height: 25),
      /*     TileAccount(
        dataUser: _user.name,
        labelTitle: 'Nome',
      ),
      TileAccount(
        dataUser: _user.email,
        labelTitle: 'Email',
      ),
      TileAccount(
        dataUser: _user.cpf,
        labelTitle: 'CPF',
      ),*/
      TileAccount(
        dataUser: 'Loja', // _user.nameStore,
        labelTitle: 'Titulo Comercial',
      ),
      SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FlatButton(
              onPressed: _loginBloc.signOut,
              padding: EdgeInsets.zero,
              textColor: Colors.red,
              child: Text(
                'Sair',
                style: TextStyle(fontWeight: FontWeight.w500),
              )),
          FlatButton.icon(
            padding: EdgeInsets.zero,
            textColor: Colors.teal,
            onPressed: () {},
            icon: Icon(CupertinoIcons.pencil),
            label: Text('Editar'),
          )
        ],
      ),
    ]);
  }
}
