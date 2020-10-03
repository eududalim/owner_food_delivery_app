import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/sign_up_bloc.dart';
import 'package:gerente_loja/view/screens/address/address_screen.dart';
import 'package:gerente_loja/view/screens/sign_up/widgets/button_sign_up.dart';
import 'package:gerente_loja/view/widgets/input_field.dart';
import 'package:gerente_loja/view/screens/sign_up/widgets/header_sign_up.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  SignUpBloc _signUpBloc;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    _signUpBloc = SignUpBloc();
    super.initState();
  }

  @override
  void dispose() {
    _signUpBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crie uma conta de anunciante'),
      ),
      key: _scaffoldKey,
      body: SafeArea(
        child: StreamBuilder<bool>(
            stream: _signUpBloc.outLoading,
            initialData: false,
            builder: (context, loading) {
              if (loading.data || !loading.hasData) {
                return Center(
                    child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                ));
              } else
                return ListView(
                  padding: const EdgeInsets.all(16.0),
                  shrinkWrap: true,
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
                      hint: 'Titulo Comercial',
                      icon: Icons.store,
                      obscure: false,
                      onChanged: _signUpBloc.changeTitleStore,
                      stream: _signUpBloc.outTitleStore,
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
                      hint: 'Celular',
                      icon: Icons.phone,
                      obscure: false,
                      onChanged: _signUpBloc.changePhone,
                      stream: _signUpBloc.outPhone,
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
                    ButtonSaveSignUp(() async {
                      String error = await _signUpBloc.signUp();
                      error.isNotEmpty
                          ? Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(
                                error,
                                textAlign: TextAlign.center,
                              ),
                              backgroundColor: Colors.redAccent,
                            ))
                          : Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddressScreen(),
                              ));
                    }),
                  ],
                );
            }),
      ),
    );
  }
}
