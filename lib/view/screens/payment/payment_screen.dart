import 'package:flutter/material.dart';
import 'package:gerente_loja/models/credit_card.dart';
import 'package:gerente_loja/view/screens/payment/components/cpf_field.dart';
import 'package:gerente_loja/view/screens/payment/components/credit_card_widget.dart';

class PaymentScreen extends StatelessWidget {
  final creditCard = CreditCard();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Pagamento'),
      ),
      body: GestureDetector(
        onTap: () {},
        child: SafeArea(
            child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Insira um Cartão de Crédito:',
                    style: TextStyle(fontSize: 16),
                  )),
              CreditCardWidget(creditCard),
              CpfField(),
              Container(
                margin: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                height: 45,
                child: RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      _scaffoldKey.currentState.showSnackBar(
                          SnackBar(content: Text('Dados Salvos com Suceeso')));
                    }
                    _scaffoldKey.currentState.showSnackBar(
                        SnackBar(content: Text('Erro ao salvar dados')));
                  },
                  child: Text(
                    'Concluir',
                    textScaleFactor: 1.2,
                  ),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  color: Theme.of(context).primaryColor,
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
