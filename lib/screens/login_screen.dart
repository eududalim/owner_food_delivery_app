import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/login_bloc.dart';
import 'package:gerente_loja/screens/home_screen.dart';
import 'package:gerente_loja/widgets/input_decoration.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginBloc = LoginBloc();

  final _emailController = TextEditingController();
  final _passController = TextEditingController();

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
    Row(
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
                        TextFormField(
                          controller: _emailController,
                          decoration: inputDecorationCustom(
                              'Email', Icons.alternate_email, context),
                        ),
                        SizedBox(height: 32),
                        TextFormField(
                          decoration: inputDecorationCustom(
                              'Senha', Icons.lock_outline, context),
                          obscureText: true,
                          controller: _passController,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FlatButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                if (_emailController.text.isEmpty)
                                  _scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        "Insira seu e-mail para recuperação!"),
                                    backgroundColor: Colors.redAccent,
                                    duration: Duration(seconds: 2),
                                  ));
                                else {
                                  //    model.recoverPass(_emailController.text);
                                  _scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    content: Text("Confira seu e-mail!"),
                                    backgroundColor: primaryColor,
                                    duration: Duration(seconds: 2),
                                  ));
                                }
                              },
                              textColor: Colors.black54,
                              child: Text('Esqueceu a senha?',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        ),
                        // Botão de Entrar
                        InkWell(
                          onTap: () {},
                          child: Container(
                            height: 40,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Theme.of(context).primaryColor),
                            child: Text(
                              'Entrar',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        //Linha do botão para criar conta
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Não tem cadastro ainda?'),
                            FlatButton(
                                onPressed: () {},
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
                        InkWell(
                          onTap: () {
                            //    model.signInGoogle(onSuccess: _cadAddress, onFail: _onFail);
                            // Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: primaryColor, width: 2.0),
                                borderRadius: BorderRadius.circular(25)),
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.all(5),
                                  child: Image.asset(
                                    'ss/google-icon.png',
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Icon(Icons.error_outline),
                                    height: 25,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Entrar com o Google',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
            } // switch
          }),
    );
  }
}
