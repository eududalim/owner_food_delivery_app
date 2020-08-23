import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  CustomBottomNavigationBar(this._page, this._pageController);

  final int _page;
  final PageController _pageController;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: _page,
        onTap: (p) {
          _pageController.animateToPage(p,
              duration: Duration(milliseconds: 500), curve: Curves.ease);
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.people_outline), title: Text("Clientes")),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), title: Text("Pedidos")),
          BottomNavigationBarItem(
              icon: Icon(Icons.list), title: Text("Produtos")),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), title: Text('Minha conta'))
        ]);
  }
}
