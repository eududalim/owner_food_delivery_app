import 'package:flutter/material.dart';

InputDecoration inputDecorationCustom(
    String hintText, IconData icon, BuildContext context) {
  return InputDecoration(
    hintText: hintText,
    // icon: Icon(icon),
    prefixIcon: Icon(icon),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Theme.of(context).primaryColor)),
  );
}
