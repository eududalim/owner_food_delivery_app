import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/sign_up_bloc.dart';
import 'package:gerente_loja/screens/address/address_screen.dart';
import 'package:gerente_loja/screens/sign_up/widgets/button_sign_up.dart';
import 'package:gerente_loja/widgets/input_field.dart';
import 'package:gerente_loja/screens/sign_up/widgets/header_sign_up.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _signUpBloc = SignUpBloc();

  @override
  void dispose() {
    super.dispose();
    _signUpBloc.dispose();
  }

  @override
  void initState() {
    super.initState();

    _signUpBloc.outState.listen((state) {
      if (state == SignUpState.SUCCESS) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
            'Conta comercial criada com sucesso!',
            textAlign: TextAlign.center,
            textScaleFactor: 1.1,
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ));
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddressScreen(),
        ));
      } else if (state == SignUpState.FAIL) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
            'Erro ao criar conta!',
            textAlign: TextAlign.center,
            textScaleFactor: 1.1,
          ),
          backgroundColor: Colors.redAccent,
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<SignUpState>(
          stream: _signUpBloc.outState,
          builder: (context, snapshot) {
            if (snapshot.data == SignUpState.LOADING) {
              return Center(child: CircularProgressIndicator());
            } else
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    HeaderSignUp(),
                    SizedBox(height: 50),
                    InputField(
                      done: false,
                      hint: 'Nome Pessoal Completo',
                      icon: Icons.person,
                      obscure: false,
                      onChanged: _signUpBloc.changeName,
                      stream: _signUpBloc.outName,
                    ),
                    SizedBox(height: 20),
                    InputField(
                      done: false,
                      hint: 'Nome Comercial',
                      icon: Icons.store,
                      obscure: false,
                      onChanged: _signUpBloc.changeNameStore,
                      stream: _signUpBloc.outNameStore,
                    ),
                    SizedBox(height: 20),
                    InputField(
                      done: false,
                      keyboardType: TextInputType.emailAddress,
                      hint: 'Email',
                      icon: Icons.alternate_email,
                      obscure: false,
                      onChanged: _signUpBloc.changeEmail,
                      stream: _signUpBloc.outEmail,
                    ),
                    SizedBox(height: 20),
                    InputField(
                      done: false,
                      keyboardType: TextInputType.number,
                      hint: 'CPF',
                      icon: Icons.perm_contact_calendar,
                      obscure: false,
                      onChanged: _signUpBloc.changeCpf,
                      stream: _signUpBloc.outCpf,
                    ),
                    SizedBox(height: 20),
                    InputField(
                      done: true,
                      hint: 'Crie uma senha',
                      icon: Icons.lock_outline,
                      obscure: true,
                      onChanged: _signUpBloc.changePassword,
                      stream: _signUpBloc.outPassword,
                    ),
                    SizedBox(height: 30),
                    StreamBuilder<bool>(
                      stream: _signUpBloc.outSubmitValid,
                      builder: (context, AsyncSnapshot<bool> snapshot) {
                        return SizedBox(
                          height: 50,
                          child: RaisedButton(
                            onPressed: snapshot.hasData
                                ? () {
                                    _signUpBloc.signUp();
                                  }
                                : () {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(
                                        'Preencha os campos corretamente!',
                                        textAlign: TextAlign.center,
                                        textScaleFactor: 1.1,
                                      ),
                                      backgroundColor: Colors.redAccent,
                                    ));
                                  },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                            color: Theme.of(context).primaryColor,
                            splashColor: Colors.grey,
                            child: Text('Criar conta comercial'),
                          ),
                        );
                      },
                    )
                  ],
                ),
              );
          }),
    );
  }
}
