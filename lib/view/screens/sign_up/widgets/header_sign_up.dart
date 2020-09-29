import 'package:flutter/material.dart';

class HeaderSignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      /*
      Container(
        color: Colors.black12,
        height: 40,
        alignment: Alignment.centerLeft,
        child: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
       
      Container(
        padding: EdgeInsets.all(10),
        child: Text(
          'Criar uma conta de anunciante',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
        ),
      ), */
      Container(
        padding: EdgeInsets.all(10),
        child: Text(
          'Aumente suas vendas e facilite' +
              ' a compra dos seus clientes anunciando em nosso app!' +
              '\nÉ rápido e fácil.',
          style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
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
              fontSize: 16),
        ),
      ),
      // FIM HEADER
    ]);
  }
}
