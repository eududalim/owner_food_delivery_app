import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

class UserAdminModel {
  String phone;
  String titleStore;
  String cpf;
  String name;
  String email;
  String uid;
  bool payment;
  Map address = {
    'cidade': '',
    'bairro': '',
    'estado': '',
    'complemento': '',
    'referencia': '',
    'rua': '',
  };

  UserAdminModel(
      {this.phone,
      this.titleStore,
      this.email,
      this.name,
      this.uid,
      this.cpf,
      this.payment = true,
      this.address});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'phone': phone,
      'titleStore': titleStore,
      'name': name,
      'email': email,
      'cpf': cpf,
      'address': address
    };
  }

  void saveToken() async {
    final token = await FirebaseMessaging().getToken();
    log(token.toString());
  }
}
