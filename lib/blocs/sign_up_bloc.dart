import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gerente_loja/validators/signup_validator.dart';
import 'package:rxdart/rxdart.dart';

enum SignUpState { LOADING, SUCESS, FAIL, IDLE }

class SignUpBloc extends BlocBase with SignUpValidator {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _nameController = BehaviorSubject<String>();
  final _nameStoreController = BehaviorSubject<String>();
  final _cpfController = BehaviorSubject<String>();
  final _stateController = BehaviorSubject<SignUpState>();

  Stream<String> get outEmail =>
      _emailController.stream.transform(validateEmail);
  Stream<String> get outPassword =>
      _passwordController.stream.transform(validatePassword);
  Stream<String> get outName => _nameController.stream.transform(validateName);
  Stream<String> get outNameStore =>
      _nameStoreController.stream.transform(validateName);
  Stream<String> get outCpf => _cpfController.stream.transform(validateCpf);
  Stream<SignUpState> get outState => _stateController.stream;

  Stream<bool> get outSubmitValid => Observable.combineLatest5(
          outEmail, outName, outNameStore, outCpf, outPassword,
          (a, b, c, d, e) {
        if (a.isEmpty || b.isEmpty || c.isEmpty || d.isEmpty || e.isEmpty) {
          return false;
        } else {
          return true;
        }
      });

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changeCpf => _cpfController.sink.add;
  Function(String) get changeNameStore => _cpfController.sink.add;

  @override
  void dispose() {
    _emailController.close();
    _passwordController.close();
    _nameController.close();
    _cpfController.close();
    _stateController.close();
    _nameStoreController.close();
  }

  void signUp() {
    final email = _emailController.value;
    final password = _passwordController.value;
    final name = _nameController.value;
    final cpf = _cpfController.value;
    final store = _nameStoreController.value;

    _stateController.add(SignUpState.LOADING);

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .catchError((e) {
      _stateController.add(SignUpState.FAIL);
    }).whenComplete(() {
      _stateController.add(SignUpState.SUCESS);

      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      Firestore.instance.collection('admins').add(
          {'adminName': name, 'email': email, 'cpf': cpf, 'nameStore': store});
    });
  }
}
