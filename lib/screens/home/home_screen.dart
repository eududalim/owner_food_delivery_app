import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/login_bloc.dart';
import 'package:gerente_loja/blocs/orders_bloc.dart';
import 'package:gerente_loja/blocs/user_bloc.dart';
import 'package:gerente_loja/tabs/my_account/my_account_tab.dart';
import 'widgets/custom_bottom_navigation_bar.dart';
import 'widgets/custom_floating_button.dart';
import 'package:gerente_loja/screens/login/login_screen.dart';
import 'package:gerente_loja/tabs/orders/orders_tab.dart';
import 'package:gerente_loja/tabs/products/products_tab.dart';
import 'package:gerente_loja/tabs/users/users_tab.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController;
  int _page = 0;

  UserBloc _userBloc;
  OrdersBloc _ordersBloc;
  final _loginBloc = LoginBloc();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _userBloc = UserBloc();
    _ordersBloc = OrdersBloc();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LoginState>(
        stream: _loginBloc.outState,
        builder: (context, snapshot) {
          if (snapshot.data == LoginState.SUCCESS) {
            return Scaffold(
              backgroundColor: Colors.grey[850],
              bottomNavigationBar:
                  CustomBottomNavigationBar(_page, _pageController),
              body: SafeArea(
                child: BlocProvider<UserBloc>(
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
                        UsersTab(),
                        OrdersTab(),
                        ProductsTab(),
                        MyAccountTab()
                      ],
                    ),
                  ),
                ),
              ),
              floatingActionButton: CustomFloatingButton(_page, _ordersBloc),
            );
          } else {
            return CupertinoAlertDialog(
              title: Text('Erro'),
              content: Text('Você ainda não possui uma conta comercial!'),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ));
                    },
                    child: Text('OK'))
              ],
            );
          }
        });
  }
}
