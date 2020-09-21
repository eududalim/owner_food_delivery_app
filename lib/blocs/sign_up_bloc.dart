import 'dart:developer';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

import 'package:gerente_loja/models/user_admin_model.dart';
import 'package:gerente_loja/validators/login_validators.dart';
import 'package:gerente_loja/validators/signup_validator.dart';

enum SignUpState { LOADING, SUCCESS, FAIL, IDLE }

class SignUpBloc extends BlocBase with SignUpValidator, LoginValidators {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _nameController = BehaviorSubject<String>();
  final _titleStoreController = BehaviorSubject<String>();
  final _phoneController = BehaviorSubject<String>();
  final _stateController = BehaviorSubject<SignUpState>();

  UserAdminModel user;

  FirebaseUser _firebaseUser;
  SignUpBloc() {
    FirebaseAuth.instance.onAuthStateChanged.listen((event) {
      _firebaseUser = event;
    });
  }

  Stream<String> get outEmail =>
      _emailController.stream.transform(validateEmail);
  Stream<String> get outPassword =>
      _passwordController.stream.transform(validatePassword);
  Stream<String> get outName => _nameController.stream.transform(validateName);
  Stream<String> get outTitleStore =>
      _titleStoreController.stream.transform(validateNameStore);
  Stream<String> get outPhone =>
      _phoneController.stream.transform(validatePhone);
  Stream<SignUpState> get outState => _stateController.stream;

/*   Stream<bool> get outSubmitValid => Observable.combineLatest5(outEmail,
      outName, outNameStore, outCpf, outPassword, (a, b, c, d, e) => true); */

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
    _stateController.close();
    _titleStoreController.close();
  }

  Future<String> signUp() async {
    _stateController.add(SignUpState.LOADING);

    user = UserAdminModel(
      email: _emailController.value,
      name: _nameController.value,
      phone: _phoneController.value,
      titleStore: _titleStoreController.value,
    );

    String password = _passwordController.value;

    String errorMessage = '';

    /// Verifica se não está nulo
    if (user.email == null || user.email.isEmpty) {
      errorMessage = 'Preencha os campos corretamente';
      _stateController.add(SignUpState.FAIL);
      return errorMessage;
    } else {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: user.email, password: password)
          .then((authResult) async {
        /// Se usuario foi criado com sucesso dá um SUCCESS e não retorna erro
        log('USUARIO CRIADO');
        user.uid = authResult.user.uid;
        _firebaseUser = authResult.user;
        await _saveDataonFirestore();
        _stateController.add(SignUpState.SUCCESS);

        /// Se houver erro ao criar usuario, verifica qual erro
      }).catchError((e) async {
        switch (e.code) {
          case 'ERROR_EMAIL_ALREADY_IN_USE':

            /// Realiza o login com o email já cadastrado
            await FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: user.email, password: password)
                .then((authResult) async {
              /// Quando conluido verifica se já possui cadastro como admin
              if (await _verifyPrivileges(authResult.user)) {
                await FirebaseAuth.instance.signOut();
                errorMessage = 'Erro! Usuario já cadastrado';
                _stateController.add(SignUpState.FAIL);
                log('USUARIO JÁ CADASTRADO, DESLOGADO, E RETORNADO UM ERRO');
              } else
                user.uid = authResult.user.uid;
              _firebaseUser = authResult.user;
              await _saveDataonFirestore();
              _stateController.add(SignUpState.FAIL);
            }).catchError((e) {
              switch (e.code) {
                case "ERROR_INVALID_EMAIL":
                  errorMessage = "Seu email está incorreto.";
                  break;
                case "ERROR_WRONG_PASSWORD":
                  errorMessage = "Sua senha está incorreta.";
                  break;
                case "ERROR_USER_NOT_FOUND":
                  errorMessage = "Usuario com este email não existe.";
                  break;
                case "ERROR_USER_DISABLED":
                  errorMessage = "O usuario com este email foi desabilitado.";
                  break;
                case "ERROR_TOO_MANY_REQUESTS":
                  errorMessage = "Muitos pedidos. Tente novamente mais tarde.";
                  break;
                case "ERROR_OPERATION_NOT_ALLOWED":
                  errorMessage = "O login com e-mail e senha não está ativado.";
                  break;
                default:
                  errorMessage = "Um erro indefinido aconteceu.";
              }
            });
            break;

          case 'ERROR_INVALID_EMAIL':
            errorMessage = 'Formato de email invalido';
            break;

          default:
            errorMessage = '';
        }

        _stateController.add(SignUpState.FAIL);
      });
    }
    return errorMessage;
  }

  Future<void> _saveDataonFirestore() async {
    await Firestore.instance
        .collection('admins')
        .document(user.uid)
        .setData(user.toMap());
  }

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

  Future<bool> _verifyIsUser(FirebaseUser user) async {
    return await Firestore.instance
        .collection('users')
        .document(user.uid)
        .get()
        .then((doc) {
      if (doc.data['name'] != null) {
        log('doc.data[name] existe. usuario possui cadastro de cliente');
        return true;
      } else
        log('usuario não possui nenhum tipo de cadastro ainda');
      return false;
    }).catchError((e) => false);
  }
}
