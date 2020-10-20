import 'package:flutter/material.dart';

class HeaderSignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: EdgeInsets.all(10),
        child: Text(
          'Aumente suas vendas e facilite' +
              ' a compra dos seus clientes anunciando em nosso app!' +
              '\nÉ rápido e fácil.' +
              '\n\nUtilize durante 30 dias totalmente de graça para experimentar.' +
              ' Após isso será cobrado uma taxa de 3% sobre cada pedido vendido' +
              ' e entregue, que será cobrado a cada mês. \nOu seja, você pagará um valor justo de acordo com seu uso.',
          style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
              fontWeight: FontWeight.w300),
        ),
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          'O primeiro mes é grátis para experimentar!',
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
