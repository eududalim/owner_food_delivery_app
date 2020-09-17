import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/account_bloc.dart';
import 'package:gerente_loja/blocs/login_bloc.dart';
import 'package:gerente_loja/models/user_admin_model.dart';

class MyAccountTab extends StatefulWidget {
  @override
  _MyAccountTabState createState() => _MyAccountTabState();
}

class _MyAccountTabState extends State<MyAccountTab> {
  InputDecoration _buildDecoration(String label) {
    return InputDecoration(
        labelText: label, labelStyle: TextStyle(color: Colors.grey));
  }

  @override
  Widget build(BuildContext context) {
    final _loginBloc = BlocProvider.of<LoginBloc>(context);
    final _fieldStyle = TextStyle(color: Colors.white, fontSize: 16);

    UserAdminModel _user = _loginBloc.userModel;
    AccountBloc accountBloc = AccountBloc(_user);

    return StreamBuilder<Map>(
        initialData: _user.toMap(_user.uid),
        stream: accountBloc.outData,
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return StreamBuilder<bool>(
                initialData: false,
                stream: accountBloc.outEnabled,
                builder: (context, enabled) {
                  return ListView(padding: EdgeInsets.all(18), children: [
                    Text(
                      'MINHA CONTA',
                      style: TextStyle(
                          fontSize: 25,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 25),
                    TextFormField(
                      enabled: enabled.data,
                      initialValue: snapshot.data['name'],
                      style: _fieldStyle,
                      decoration: _buildDecoration("Nome"),
                    ),
                    TextFormField(
                      enabled: false,
                      initialValue: snapshot.data['email'],
                      style: _fieldStyle,
                      decoration: _buildDecoration("Email"),
                    ),
                    TextFormField(
                      enabled: enabled.data,
                      initialValue: snapshot.data['phone'],
                      style: _fieldStyle,
                      decoration: _buildDecoration("Telefone"),
                    ),
                    TextFormField(
                      enabled: enabled.data,
                      initialValue: snapshot.data['titleStore'],
                      style: _fieldStyle,
                      decoration: _buildDecoration("Titulo comercial"),
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
                });
        });
  }
}
