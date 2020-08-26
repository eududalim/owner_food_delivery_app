import 'package:flutter/material.dart';

class HeaderSignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
            alignment: Alignment.centerLeft,
          ),
        ],
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        child: Text(
          'Criar uma conta de anunciante',
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.w300),
        ),
      ),
      Container(
        padding: EdgeInsets.all(20),
        child: Text(
          'Aumente suas vendas e facilite' +
              ' a compra dos seus clientes anunciando em nosso app!' +
              '\nÉ rápido e fácil.',
          style: TextStyle(
              color: Colors.grey[700],
              fontSize: 18,
              fontWeight: FontWeight.w300),
        ),
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'Os primeiros 2 meses são grátis!',
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w700,
              fontSize: 18),
        ),
      ),
      // FIM HEADER
    ]);
  }
}
