import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/login_bloc.dart';
import 'package:gerente_loja/view/screens/home/home_screen.dart';
import 'package:gerente_loja/view/screens/login/login_screen.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LoginBloc _loginBloc = BlocProvider.of<LoginBloc>(context);
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: StreamBuilder<LoginState>(
          stream: _loginBloc.outState,
          initialData: LoginState.LOADING,
          builder: (context, snapshot) {
            return SplashScreen(
              seconds: 2,
              loaderColor: Colors.white,
              photoSize: 70,
              image: Image(
                image: AssetImage('assets/delivery-icon-secondary.png'),
              ),
              title: Text('Vem Delivery \n App do Anunciante',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w500)),
              backgroundColor: Theme.of(context).primaryColor,
              navigateAfterSeconds: snapshot.data == LoginState.SUCCESS
                  ? HomeScreen()
                  : LoginScreen(),
            );
          }),
    );
  }
}
