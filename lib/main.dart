import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/login_bloc.dart';
import 'package:gerente_loja/view/screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _loginBloc = LoginBloc();

    return BlocProvider<LoginBloc>(
      bloc: _loginBloc,
      child: MaterialApp(
        title: 'Vem Delivery para Anunciantes',
        theme: ThemeData(
            primaryColor: Colors.teal[400], primaryColorDark: Colors.teal[800]),
        debugShowCheckedModeBanner: false,
        home: SplashScreenPage(),
      ),
    );
  }
}
