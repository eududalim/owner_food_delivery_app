import 'package:bloc_pattern/bloc_pattern.dart';
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

  UserClientBloc _userBloc;
  OrdersBloc _ordersBloc;

  @override
  initState() {
    super.initState();
    _pageController = PageController();
    _userBloc = UserClientBloc();
    _ordersBloc = OrdersBloc();
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
    final _loginBloc = BlocProvider.of<LoginBloc>(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: CustomBottomNavigationBar(_page, _pageController),
      body: StreamBuilder<LoginState>(
          stream: _loginBloc.outState,
          builder: (context, state) {
            if (state.data == LoginState.FAIL ||
                state.data == LoginState.IDLE) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => BlocProvider<LoginBloc>(
                    bloc: _loginBloc, child: LoginScreen()),
              ));
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
