import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gerente_loja/models/user_admin_model.dart';
import 'package:gerente_loja/repositories/user_admin_repo.dart';
import 'package:gerente_loja/validators/login_validators.dart';
import 'package:gerente_loja/validators/signup_validator.dart';
import 'package:rxdart/rxdart.dart';

enum SignUpState { LOADING, SUCCESS, FAIL, IDLE }

class SignUpBloc extends BlocBase with SignUpValidator, LoginValidators {
  UserAdminRepo _adminRepo;

  SignUpBloc() {
    _adminRepo = UserAdminRepo();
  }

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
      _nameStoreController.stream.transform(validateNameStore);
  Stream<String> get outCpf => _cpfController.stream.transform(validateCpf);
  Stream<SignUpState> get outState => _stateController.stream;

/*   Stream<bool> get outSubmitValid => Observable.combineLatest5(outEmail,
      outName, outNameStore, outCpf, outPassword, (a, b, c, d, e) => true); */

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changeCpf => _cpfController.sink.add;
  Function(String) get changeNameStore => _nameStoreController.sink.add;

  @override
  void dispose() {
    _emailController.close();
    _passwordController.close();
    _nameController.close();
    _cpfController.close();
    _stateController.close();
    _nameStoreController.close();
  }

  void signUp() async {
    UserAdminModel user = UserAdminModel(
      email: _emailController.value,
      name: _nameController.value,
      phone: _cpfController.value,
      titleStore: _nameStoreController.value,
    );
    String password = _passwordController.value;

    if (user.email == null || user.email.isEmpty) {
      _stateController.add(SignUpState.FAIL);
      return;
    } else {
      _stateController.add(SignUpState.LOADING);

      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: user.email, password: password)
          .whenComplete(() => _stateController.add(SignUpState.SUCCESS))
          .catchError((e) => _stateController.add(SignUpState.FAIL));
    }
  }
}
