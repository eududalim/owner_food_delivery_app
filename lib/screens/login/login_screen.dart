import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/login_bloc.dart';
import 'package:gerente_loja/screens/home/home_screen.dart';
import 'package:gerente_loja/screens/login/widgets/button_sign_in.dart';
import 'package:gerente_loja/screens/login/widgets/button_sign_up.dart';
import 'package:gerente_loja/widgets/input_field.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginBloc = LoginBloc();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _loginBloc.outState.listen((state) {
      switch (state) {
        case LoginState.SUCCESS:
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()));
          break;
        case LoginState.FAIL:
          showCupertinoDialog(
              barrierDismissible: true,
              context: context,
              builder: (context) => CupertinoAlertDialog(
                    title: Text("Erro"),
                    content: Text("Você ainda não possui uma conta comercial!"),
                  ));
          break;
        case LoginState.LOADING:
        case LoginState.IDLE:
      }
    });
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  Row _header() {
    return Row(
      children: [
        Icon(
          Icons.store,
          size: 100,
          color: Theme.of(context).primaryColor,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vem Delivery',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
            ),
            Text(
              'App do Anunciante',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            )
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[50],
      body: StreamBuilder<LoginState>(
          stream: _loginBloc.outState,
          // ignore: missing_return
          builder: (context, snapshot) {
            switch (snapshot.data) {
              case LoginState.LOADING:
                return Center(child: CircularProgressIndicator());
              case LoginState.IDLE:
              case LoginState.SUCCESS:
              case LoginState.FAIL:
                return Form(
                  key: _formKey,
                  child: Center(
                    child: ListView(
                      padding: EdgeInsets.all(30),
                      shrinkWrap: true,
                      children: [
                        _header(),
                        SizedBox(height: 32),
                        InputField(
                          done: false,
                          keyboardType: TextInputType.emailAddress,
                          icon: Icons.alternate_email,
                          hint: "Email",
                          obscure: false,
                          stream: _loginBloc.outEmail,
                          onChanged: _loginBloc.changeEmail,
                        ),
                        SizedBox(height: 32),
                        InputField(
                          done: true,
                          icon: Icons.lock_outline,
                          hint: "Senha",
                          obscure: true,
                          stream: _loginBloc.outPassword,
                          onChanged: _loginBloc.changePassword,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FlatButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {},
                              textColor: Colors.black54,
                              child: Text('Esqueceu a senha?',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        ),
                        // Botão de Entrar
                        StreamBuilder<bool>(
                          stream: _loginBloc.outSubmitValid,
                          builder: (context, snapshot) {
                            return InkWell(
                                onTap: snapshot.hasData
                                    ? _loginBloc.submit
                                    : () {
                                        Scaffold.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                            'Preencha os campos corretamente!',
                                            textAlign: TextAlign.center,
                                            textScaleFactor: 1.1,
                                          ),
                                          backgroundColor: Colors.redAccent,
                                        ));
                                      },
                                child: ButtonSignIn());
                          },
                        ),
                        SizedBox(height: 15),
                        ButtonSignUp(),
                        /* 
                             Divider(),
                        Text(
                          '',
                          textAlign: TextAlign.center,
                        ),
                        Divider(),
                        SizedBox(height: 15),
                        Botão do Sign com Google */
                      ],
                    ),
                  ),
                );
              default:
                return Container(
                  width: 0,
                  height: 0,
                );
            } // switch
          }),
    );
  }
}
