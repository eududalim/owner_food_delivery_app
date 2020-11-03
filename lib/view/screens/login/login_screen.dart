import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/login_bloc.dart';
import 'package:gerente_loja/view/screens/home/home_screen.dart';
import 'package:gerente_loja/view/screens/login/widgets/button_pass_rec.dart';
import 'package:gerente_loja/view/screens/login/widgets/button_sign_in.dart';
import 'package:gerente_loja/view/screens/login/widgets/button_sign_up.dart';
import 'package:gerente_loja/view/screens/login/widgets/header_login.dart';
import 'package:gerente_loja/view/screens/payment/payment_screen.dart';
import 'package:gerente_loja/view/widgets/input_field.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final _loginBloc = BlocProvider.of<LoginBloc>(context);
    return Scaffold(
      key: _scaffoldKey,
      body: StreamBuilder<bool>(
          stream: _loginBloc.outLoading,
          initialData: false,
          builder: (context, loading) {
            if (!loading.hasData) return Container();
            if (loading.data)
              return Center(
                  child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation(Theme.of(context).primaryColor),
              ));
            return Form(
              key: _formKey,
              child: Center(
                child: ListView(
                  padding: EdgeInsets.all(30),
                  shrinkWrap: true,
                  children: [
                    HeaderLogin(),
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
                    ButtonPasswordRecover(_loginBloc.recoveryPassword),
                    // Botão de Entrar
                    InkWell(
                        onTap: () async {
                          String error = await _loginBloc.submit();
                          if (error.isNotEmpty) {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text(
                                error,
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.1,
                              ),
                              backgroundColor: Colors.redAccent,
                            ));
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                          }
                        },
                        //: _infoUser,
                        child: ButtonSignIn()),
                    SizedBox(height: 15),
                    ButtonSignUp(),
                  ],
                ),
              ),
            );
          }),
    );
  }

  void _infoUser() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        'Preencha os campos corretamente!',
        textAlign: TextAlign.center,
        textScaleFactor: 1.1,
      ),
      backgroundColor: Colors.redAccent,
    ));
  }
}
