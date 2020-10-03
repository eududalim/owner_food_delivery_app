import 'dart:developer';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gerente_loja/validators/address_validators.dart';
import 'package:rxdart/rxdart.dart';

class AddressBloc extends BlocBase with AddressValidators {
  @override
  void dispose() {
    _loadingController.close();
    _ruaController.close();
    _bairroController.close();
    _cidadeController.close();
    _estadoController.close();
    _complementoController.close();
    _referenciaController.close();
  }

  final _ruaController = BehaviorSubject<String>();
  final _bairroController = BehaviorSubject<String>();
  final _cidadeController = BehaviorSubject<String>();
  final _estadoController = BehaviorSubject<String>();
  final _complementoController = BehaviorSubject<String>();
  final _referenciaController = BehaviorSubject<String>();
  final _loadingController = BehaviorSubject<bool>();

  Function(String) get changeRua => _ruaController.sink.add;
  Function(String) get changeBairro => _bairroController.sink.add;
  Function(String) get changeCidade => _cidadeController.sink.add;
  Function(String) get changeEstado => _estadoController.sink.add;
  Function(String) get changeComplemento => _complementoController.sink.add;
  Function(String) get changeReferencia => _referenciaController.sink.add;

  Stream<bool> get outLoading => _loadingController.stream;
  Stream<String> get outRua => _ruaController.stream.transform(validateRua);
  Stream<String> get outBairro =>
      _bairroController.stream.transform(validateBairro);
  Stream<String> get outCidade =>
      _cidadeController.stream.transform(validateCidade);
  Stream<String> get outEstado =>
      _estadoController.stream.transform(validateEstado);
  Stream<String> get outComplemento => _complementoController.stream;
  Stream<String> get outReferencia =>
      _referenciaController.stream.transform(validateReferencia);

  ///
  /// Functions
  ///
  Future<String> saveAddress() async {
    String message = '';
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    if (user == null) {
      message = 'Usuario não conectado';
      return message;
    }

    Map<String, dynamic> address = {
      'cidade': _cidadeController.value,
      'bairro': _bairroController.value,
      'estado': _estadoController.value,
      'complemento': _complementoController.value,
      'referencia': _referenciaController.value,
      'rua': _ruaController.value,
    };

    await Firestore.instance
        .collection('admins')
        .document(user.uid)
        .setData({'address': address}).catchError((error) {
      message = 'Ocorreu um erro. Tente novamente!';
    });

    return message;
  }
}
