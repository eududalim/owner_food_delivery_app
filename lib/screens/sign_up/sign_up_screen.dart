import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/sign_up_bloc.dart';
import 'package:gerente_loja/screens/address/address_screen.dart';
import 'package:gerente_loja/screens/login/widgets/input_field.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _signUpBloc = SignUpBloc();

  Column _header(context) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<SignUpState>(
          stream: _signUpBloc.outState,
          builder: (context, snapshot) {
            if (snapshot.data == SignUpState.LOADING) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.data == SignUpState.SUCESS) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddressScreen(),
              ));
            }
            if (snapshot.data == SignUpState.FAIL) {
              showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                        title: Text('Houve algum erro'),
                        content: Text('Verifique os dados e tente novamente!'),
                      ));
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  _header(context),
                  SizedBox(height: 50),
                  InputField(
                    hint: 'Nome Pessoal Completo',
                    icon: Icons.person,
                    obscure: false,
                    onChanged: _signUpBloc.changeName,
                    stream: _signUpBloc.outName,
                  ),
                  SizedBox(height: 20),
                  InputField(
                    hint: 'Nome Comercial',
                    icon: Icons.store,
                    obscure: false,
                    onChanged: _signUpBloc.changeName,
                    stream: _signUpBloc.outName,
                  ),
                  SizedBox(height: 20),
                  InputField(
                    hint: 'Email',
                    icon: Icons.alternate_email,
                    obscure: false,
                    onChanged: _signUpBloc.changeEmail,
                    stream: _signUpBloc.outEmail,
                  ),
                  SizedBox(height: 20),
                  InputField(
                    hint: 'CPF',
                    icon: Icons.perm_contact_calendar,
                    obscure: false,
                    onChanged: _signUpBloc.changeCpf,
                    stream: _signUpBloc.outCpf,
                  ),
                  SizedBox(height: 20),
                  InputField(
                    hint: 'Crie uma senha',
                    icon: Icons.lock_outline,
                    obscure: true,
                    onChanged: _signUpBloc.changePassword,
                    stream: _signUpBloc.outPassword,
                  ),
                  SizedBox(height: 30),
                  StreamBuilder<bool>(
                      stream: _signUpBloc.outSubmitValid,
                      builder: (context, snapshot) {
                        return SizedBox(
                          height: 50,
                          child: RaisedButton(
                            onPressed:
                                snapshot.data ? _signUpBloc.signUp : null,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                            color: Theme.of(context).primaryColor,
                            splashColor: Colors.grey,
                            child: Text('Criar conta comercial'),
                          ),
                        );
                      })
                ],
              ),
            );
          }),
    );
  }
}
