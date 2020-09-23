import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/login_bloc.dart';
import 'package:gerente_loja/view/screens/home/home_screen.dart';
import 'package:gerente_loja/view/screens/login/widgets/button_pass_rec.dart';
import 'package:gerente_loja/view/screens/login/widgets/button_sign_in.dart';
import 'package:gerente_loja/view/screens/login/widgets/button_sign_up.dart';
import 'package:gerente_loja/view/screens/login/widgets/header_login.dart';
import 'package:gerente_loja/view/widgets/input_field.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc _loginBloc;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc();

    _loginBloc.outState.listen((state) {
      if (state == LoginState.SUCCESS)
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: StreamBuilder<LoginState>(
          stream: _loginBloc.outState,
          initialData: LoginState.LOADING,
          builder: (context, state) {
            switch (state.data) {
              case LoginState.SUCCESS:
              case LoginState.LOADING:
                return Center(child: CircularProgressIndicator());
                break;
              case LoginState.FAIL:
              case LoginState.IDLE:
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
                          hint: "Email", // teste
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
                        ButtonPasswordRecover(),
                        // Botão de Entrar
                        StreamBuilder<bool>(
                          stream: _loginBloc.outSubmitValid,
                          builder: (context, snapshot) {
                            return InkWell(
                                onTap: snapshot.hasData ? _submit : _infoUser,
                                child: ButtonSignIn());
                          },
                        ),
                        SizedBox(height: 15),
                        ButtonSignUp(),
                      ],
                    ),
                  ),
                );
              default:
            } // switch
            return Container();
          }),
    );
  }

  void _submit() async {
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
    }
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
