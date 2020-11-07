import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:gerente_loja/blocs/login_bloc.dart';
import 'package:gerente_loja/blocs/orders_bloc.dart';
import 'package:gerente_loja/blocs/user_client_bloc.dart';
import 'package:gerente_loja/view/screens/home/widgets/custom_floating_button.dart';
import 'package:gerente_loja/view/screens/login/login_screen.dart';
import 'package:gerente_loja/view/tabs/my_account/my_account_tab.dart';
import 'package:gerente_loja/view/tabs/orders/orders_tab.dart';
import 'package:gerente_loja/view/tabs/products/products_tab.dart';

import 'widgets/custom_bottom_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController;
  int _page = 0;
  bool dialog = false;

  UserClientBloc _userBloc;
  OrdersBloc _ordersBloc;
  LoginBloc _loginBloc;

  void configFCM() {
    final fcm = FirebaseMessaging();

    if (Platform.isIOS) {
      fcm.requestNotificationPermissions(
          const IosNotificationSettings(provisional: true));
    }

    fcm.configure(onLaunch: (Map<String, dynamic> message) async {
      print('onLaunch $message');
    }, onResume: (Map<String, dynamic> message) async {
      print('onResume $message');
    }, onMessage: (Map<String, dynamic> message) async {
      showNotification(
        message['notification']['title'] as String,
        message['notification']['body'] as String,
      );
    });
  }

  void showNotification(String title, String message) {
    Flushbar(
      title: title,
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      isDismissible: true,
      backgroundColor: Theme.of(context).primaryColor,
      duration: const Duration(seconds: 5),
      icon: Icon(
        Icons.shopping_cart,
        color: Colors.white,
      ),
    ).show(context);
  }

  @override
  initState() {
    super.initState();
    _pageController = PageController();
    _userBloc = UserClientBloc();

    configFCM();
  }

  @override
  void didChangeDependencies() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _ordersBloc = OrdersBloc(_loginBloc.userModel.uid);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _ordersBloc.dispose();
    _userBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final _loginBloc = BlocProvider.of<LoginBloc>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: CustomBottomNavigationBar(_page, _pageController),
      body: StreamBuilder<LoginState>(
          stream: _loginBloc.outState,
          builder: (context, state) {
            if (state.data == LoginState.FAIL ||
                state.data == LoginState.IDLE) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ));
              });
            }

            return SafeArea(
              child: BlocProvider<UserClientBloc>(
                bloc: _userBloc,
                child: BlocProvider<OrdersBloc>(
                  bloc: _ordersBloc,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (p) {
                      setState(() {
                        _page = p;
                      });
                    },
                    children: <Widget>[
                      /// UsersTab(),
                      OrdersTab(),
                      ProductsTab(),
                      MyAccountTab()
                    ],
                  ),
                ),
              ),
            );
          }),
      floatingActionButton: CustomFloatingButton(_page, _ordersBloc),
    );
  }
}
