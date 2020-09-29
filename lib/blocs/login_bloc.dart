import 'dart:async';
import 'dart:developer';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gerente_loja/models/user_admin_model.dart';
import 'package:gerente_loja/validators/login_validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum LoginState { IDLE, LOADING, SUCCESS, FAIL }

class LoginBloc extends BlocBase with LoginValidators {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _stateController = BehaviorSubject<LoginState>();

  Stream<String> get outEmail =>
      _emailController.stream.transform(validateEmail);
  Stream<String> get outPassword =>
      _passwordController.stream.transform(validatePassword);
  Stream<LoginState> get outState => _stateController.stream;

  Stream<bool> get outSubmitValid =>
      Observable.combineLatest2(outEmail, outPassword, (a, b) => true);

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  StreamSubscription _streamSubscription;

  UserAdminModel userModel;

  LoginBloc() {
    userModel = UserAdminModel();

    try {
      _streamSubscription =
          FirebaseAuth.instance.onAuthStateChanged.listen((user) async {
        if (user != null) {
          if (await verifyPrivileges(user)) {
            await Firestore.instance
                .collection('admins')
                .document(user.uid)
                .get()
                .then((doc) {
              userModel.name = doc.data['name'];
              userModel.phone = doc.data['phone'];
              userModel.titleStore = doc.data['titleStore'];
              userModel.email = doc.data['email'];
              userModel.uid = user.uid;
              userModel.address = doc.data['address'];
            });
            _stateController.add(LoginState.SUCCESS);
          } else {
            FirebaseAuth.instance.signOut();
            _stateController.add(LoginState.FAIL);
          }
        } else {
          _stateController.add(LoginState.IDLE);
        }
      });
    } on Exception catch (e) {
      _stateController.add(LoginState.FAIL);
    }
  }

  Future<String> submit() async {
    final email = _emailController.value;
    final password = _passwordController.value;
    String message = '';

    _stateController.add(LoginState.LOADING);
    log('LoginState.Loading');

    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      _stateController.add(LoginState.SUCCESS);
      log('LoginState.SUCCESS');
    }).catchError((e) {
      _stateController.add(LoginState.FAIL);
      switch (e.code) {
        case 'ERROR_INVALID_EMAIL':
          message = 'Email inválido.';
          break;
        case 'ERROR_WRONG_PASSWORD':
          message = 'Senha incorreta.';
          break;
        case 'ERROR_USER_NOT_FOUND':
          message = 'Usuario não cadastrado.';
          break;
        case 'ERROR_USER_DISABLED':
          message = 'Usuario desabilitado.';
          break;
        case 'ERROR_TOO_MANY_REQUESTS':
          message =
              'Foram feitas muitas tentativas. Aguarde alguns instantes e tente novamente.';
          break;
        case 'ERROR_OPERATION_NOT_ALLOWED':
          message = 'Verique os campos e tente novamente.';
          break;
        default:
          message = 'Algo deu errado. Tente novmente.';
      }
    });

    return message;
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
    _stateController.add(LoginState.FAIL);
    log('SignOut finish. LoginState.FAIL');
  }

  Future<bool> verifyPrivileges(FirebaseUser user) async {
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

  @override
  void dispose() {
    _emailController.close();
    _passwordController.close();
    _stateController.close();

    _streamSubscription.cancel();
  }
}
