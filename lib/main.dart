import 'package:flutter/material.dart';
import 'package:gerente_loja/view/screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vem Delivery para Anunciantes',
      theme: ThemeData(
        primaryColor: Colors.teal[400],
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreenPage(),
    );
  }
}
