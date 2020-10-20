import 'package:flutter/material.dart';
import 'package:gerente_loja/models/credit_card.dart';
import 'package:gerente_loja/view/screens/payment/components/credit_card_widget.dart';

class PaymentScreen extends StatelessWidget {
  final creditCard = CreditCard();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagamento'),
      ),
      body: GestureDetector(
        onTap: () {},
        child: SafeArea(
            child: ListView(
          children: [
            Text('Insira um Cartão de Crédito'),
            CreditCardWidget(creditCard),
          ],
        )),
      ),
    );
  }
}
