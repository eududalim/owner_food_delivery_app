import 'package:flutter/material.dart';

class MyAccountTab extends StatefulWidget {
  @override
  _MyAccountTabState createState() => _MyAccountTabState();
}

class _MyAccountTabState extends State<MyAccountTab> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(builder: (context, snapshot) {
      return ListView(children: [
        ListTile(
          title: Text('Nome pessoal: '),
        )
      ]);
    });
  }
}
