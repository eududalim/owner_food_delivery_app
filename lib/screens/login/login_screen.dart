import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/login_bloc.dart';
import 'package:gerente_loja/blocs/sign_in_google.dart';
import 'package:gerente_loja/screens/home/home_screen.dart';
import 'package:gerente_loja/screens/sign_up/sign_up_screen.dart';
import 'package:gerente_loja/screens/login/widgets/input_field.dart';

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
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ));
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("Erro"),
                    content: Text("Você não possui os privilégios necessários"),
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
    Color primaryColor = Theme.of(context).primaryColor;

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
                          icon: Icons.alternate_email,
                          hint: "Email",
                          obscure: false,
                          stream: _loginBloc.outEmail,
                          onChanged: _loginBloc.changeEmail,
                        ),
                        SizedBox(height: 32),
                        InputField(
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
                              onTap:
                                  snapshot.hasData ? _loginBloc.submit : null,
                              child: Container(
                                height: 50,
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Theme.of(context).primaryColor),
                                child: Text(
                                  'Entrar',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 15),
                        //Linha do botão para criar conta
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Não tem cadastro ainda?'),
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SignUpScreen(),
                                  ));
                                },
                                child: Text(
                                  'Crie um conta',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold),
                                ))
                          ],
                        ),
                        Divider(),
                        Text(
                          'ou',
                          textAlign: TextAlign.center,
                        ),
                        Divider(),
                        SizedBox(height: 15),
                        //Botão do Sign com Google
                        OutlineButton(
                          splashColor: Colors.grey,
                          onPressed: () {
                            signInWithGoogle().whenComplete(() {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ));
                            });
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                          highlightElevation: 0,
                          borderSide: BorderSide(color: Colors.grey),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image(
                                  image: AssetImage("assets/google-icon.png"),
                                  height: 35,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    'Entrar com Google',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
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
