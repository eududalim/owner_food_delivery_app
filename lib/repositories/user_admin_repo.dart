import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gerente_loja/models/user_admin_model.dart';

class UserAdminRepo {
  FirebaseUser _firebaseUser;
  UserAdminModel user = UserAdminModel();

  UserAdminRepo() {
    loadCurrentUser();
  }

  void _saveData(UserAdminModel user, uid) async {
    await Firestore.instance
        .collection('admins')
        .document(uid)
        .setData(user.toMap(uid));
  }

  Future<bool> createUser(UserAdminModel user) async {
    String uid = await _haveAccount(user.email, user.password);
    if (uid != null) {
      log('USUARIO JÁ CADASTRADO NO FIREBASE. SALVANDO USUARIO COMO ADMIN...');
      _saveData(user, uid);
      // loadCurrentUser();
      return true;
    } else {
      log('USUARIO NÃO CADASTRADO NO BANCO DE DADOS AINDA. CRIANDO USUARIO...');
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: user.email, password: user.password)
          .then((value) {
        _firebaseUser = value.user;
        _saveData(user, _firebaseUser.uid);
        // loadCurrentUser();
        log('USUARIO CRIADO COM SUCESSO!');
        return true;
      }).catchError((e) {
        log('ERRO AO CRIAR USUARIO!');
        return false;
      });
      return false;
    }
  }

  // ignore: missing_return
  Future<String> _haveAccount(email, password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        _firebaseUser = value.user;
        return _firebaseUser.uid;
      });
    } on AuthException catch (e) {
      print('Falha com erro code: ${e.code}');
      print(e.message);
      return null;
    }
  }

  Future<bool> signIn(email, password) async => await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        if (await isAdmin(value.user.uid)) return true;
      }).catchError((e) {
        print('ERROR: ' + e.toString());
        return false;
      });

  Future<bool> isAdmin(uid) async => await Firestore.instance
          .collection('admins')
          .document(uid)
          .get()
          .then((value) {
        if (value == null)
          return false;
        else
          return true;
      });

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  bool loadCurrentUser() {
    if (_firebaseUser == null)
      FirebaseAuth.instance.onAuthStateChanged.listen((user) {
        _firebaseUser = user;
      });
    if (_firebaseUser != null)
      return true;
    else
      return false;
  }

  Future<DocumentSnapshot> get getUser async => await Firestore.instance
      .collection('admins')
      .document(_firebaseUser.uid)
      .get();
}
