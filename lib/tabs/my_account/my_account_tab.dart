import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/admin_data_bloc.dart';

class MyAccountTab extends StatefulWidget {
  @override
  _MyAccountTabState createState() => _MyAccountTabState();
}

class _MyAccountTabState extends State<MyAccountTab> {
  AdminDataBloc _adminDataBloc = AdminDataBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
        stream: _adminDataBloc.outAdminData,
        builder: (context, snapshot) {
          return ListView(children: [
            ListTile(
              title: Text('Nome pessoal: '),
            )
          ]);
        });
  }
}
