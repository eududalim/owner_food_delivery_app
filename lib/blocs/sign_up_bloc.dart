import 'dart:developer';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

import 'package:gerente_loja/models/user_admin_model.dart';
import 'package:gerente_loja/validators/login_validators.dart';
import 'package:gerente_loja/validators/signup_validator.dart';

class SignUpBloc extends BlocBase with SignUpValidator, LoginValidators {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _nameController = BehaviorSubject<String>();
  final _titleStoreController = BehaviorSubject<String>();
  final _phoneController = BehaviorSubject<String>();
  final _loadingController = BehaviorSubject<bool>();

  UserAdminModel user;

  FirebaseUser _firebaseUser;

  Stream<String> get outEmail =>
      _emailController.stream.transform(validateEmail);
  Stream<String> get outPassword =>
      _passwordController.stream.transform(validatePassword);
  Stream<String> get outName => _nameController.stream.transform(validateName);
  Stream<String> get outTitleStore =>
      _titleStoreController.stream.transform(validateNameStore);
  Stream<String> get outPhone =>
      _phoneController.stream.transform(validatePhone);
  Stream<bool> get outLoading => _loadingController.stream;

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changePhone => _phoneController.sink.add;
  Function(String) get changeTitleStore => _titleStoreController.sink.add;

  @override
  void dispose() {
    _emailController.close();
    _passwordController.close();
    _nameController.close();
    _phoneController.close();
    _loadingController.close();
    _titleStoreController.close();
  }

  Future<String> signUp() async {
    _loadingController.add(true);
    user = UserAdminModel(
      email: _emailController.value,
      name: _nameController.value,
      phone: _phoneController.value,
      titleStore: _titleStoreController.value,
    );
    String password = _passwordController.value;
    String message;

    /// Verifica se não está nulo
    if (user.email == null || user.email.isEmpty) {
      message = 'Preencha os campos corretamente';
      _loadingController.add(false);
      return message;
    } else {
      ///Cria usuario
      PlatformException error = await _createUser(user.email, password);
      if (error != null)
        switch (error.code) {
          case 'ERROR_EMAIL_ALREADY_IN_USE':
            message = await _signIn(user.email, password);
            break;
          case 'ERROR_INVALID_EMAIL':
            message = 'Formato de email invalido';
            break;
          default:
            message = '';
        }

      _loadingController.add(false);
      return message;
    }
  }

  ///Function to create admin user with email in use

  // ignore: missing_return
  Future<String> _signIn(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((authResult) async {
      if (await _verifyPrivileges(authResult.user)) {
        await FirebaseAuth.instance.signOut();
        return 'Usuario já cadastrado. Faça login para continuar.';
      } else
        user.uid = authResult.user.uid;
      _firebaseUser = authResult.user;
      await _saveDataonFirestore();
      return '';
    }).catchError((error) async => _errorHandlingSignIn(error));
  }

  /// Function for save data on Firebase

  Future<void> _saveDataonFirestore() async {
    await Firestore.instance
        .collection('admins')
        .document(user.uid)
        .setData(user.toMap())
        .catchError((e) {
      log(e.toString());
    });
  }

  /// Function for verify if user have privilegies

  Future<bool> _verifyPrivileges(user) async {
    return await Firestore.instance
        .collection('admins')
        .document(user.uid)
        .get()
        .then((doc) {
      if (doc.data['name'] != null) {
        log('doc.data[name] existe. usuario com privilegio');
        return true;
      } else
        log('usuario sem privilégio');
      return false;
    }).catchError((e) => false);
  }

  /// Function for create user on Firebase and Firestore with email and pass

  Future<PlatformException> _createUser(String email, String password) async {
    return await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((authResult) async {
      log('USUARIO CRIADO');
      user.uid = authResult.user.uid;
      _firebaseUser = authResult.user;
      await _saveDataonFirestore();
      log('dados salvos');
      return null;
    }).catchError((error) => error);
  }

  /// Function for error handling when try subscription of user
  /// with email already in use

  String _errorHandlingSignIn(PlatformException error) {
    switch (error.code) {
      case "ERROR_INVALID_EMAIL":
        return "Seu email está incorreto.";
        break;
      case "ERROR_WRONG_PASSWORD":
        return "Sua senha está incorreta.";
        break;
      case "ERROR_USER_NOT_FOUND":
        return "Usuario com este email não existe.";
        break;
      case "ERROR_USER_DISABLED":
        return "O usuario com este email foi desabilitado.";
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        return "Muitos pedidos. Tente novamente mais tarde.";
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        return "O login com e-mail e senha não está ativado.";
        break;
      default:
        return "Um erro indefinido aconteceu.";
    }
  }
}
