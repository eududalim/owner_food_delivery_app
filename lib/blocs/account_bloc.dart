import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gerente_loja/models/user_admin_model.dart';
import 'package:rxdart/rxdart.dart';

class AccountBloc extends BlocBase {
  final _dataController = BehaviorSubject<Map>();
  final _enabledController = BehaviorSubject<bool>();
  final _loadingController = BehaviorSubject<bool>();

  Stream<Map> get outData => _dataController.stream;
  Stream<bool> get outEnabled => _enabledController.stream;
  Stream<bool> get outLoading => _loadingController.stream;

  Map<String, dynamic> dataAddress = {
    'name': '',
    'titleStore': '',
    'phone': '',
    'email': '',
    'uid': '',
    'address': {
      'rua': '',
      'bairro': '',
      'cidade': '',
      'estado': '',
      'complemento': '',
      'referencia': ''
    }
  };

  void saveTitleStore(String title) {
    dataAddress["titleStore"] = title;
  }

  void saveName(String name) {
    dataAddress["name"] = name;
  }

  void saveEmail(String email) {
    dataAddress["email"] = email;
  }

  void savePhone(String phone) {
    dataAddress["phone"] = phone;
  }

//////ENDEREÇO///////////////////////////////
  void saveRua(String text) {
    dataAddress['address']['rua'] = text;
  }

  void saveNumRua(String text) {
    dataAddress['address']['numRua'] = text;
  }

  void saveCidade(String text) {
    dataAddress['address']['cidade'] = text;
  }

  void saveEstado(String text) {
    dataAddress['address']['estado'] = text;
  }

  void saveBairro(String text) {
    dataAddress['address']['bairro'] = text;
  }

  void saveComplemento(String text) {
    dataAddress['address']['complemento'] = text;
  }

  void saveReferencia(String text) {
    dataAddress['address']['referencia'] = text;
  }

  /// Validações
  /// Endereço
  ///
  String validate(String text) {
    if (text.isEmpty) return "Campo Obrigatorio!";
    return null;
  }

  ///
  //////// VALIDAÇÕES //////////////
  /// Dados pessoais /////
  String validateTitleStore(String text) {
    if (text.isEmpty) return "Preencha o título comercial";
    return null;
  }

  String validateName(String text) {
    if (text.isEmpty) return "Preencha com o seu nome completo";
    return null;
  }

  String validatePhone(String text) {
    const _regExp = r'^\([1-9]{2}\) (?:[2-8]|9[1-9])[0-9]{3}\-[0-9]{4}$';
    if (!text.contains(RegExp(_regExp)))
      return "Preencha com o seu numero de celular";
    return null;
  }

  String validateEmail(String text) {
    if (text.isEmpty || !text.contains('@')) return "Preencha o seu email";
    return null;
  }

  void enabledEdit() {
    _enabledController.add(true);
  }

  Future<bool> saveData(uid) async {
    _enabledController.add(false);
    _loadingController.add(true);

    bool sucess;

    await Firestore.instance
        .collection('admins')
        .document(uid)
        .updateData(dataAddress)
        .whenComplete(() {
      sucess = true;
    }).catchError((e) {
      sucess = false;
    });

    _loadingController.add(false);
    return sucess;
  }

  AccountBloc(UserAdminModel user) {
    dataAddress = {
      'name': user.name,
      'titleStore': user.titleStore,
      'phone': user.phone,
      'email': user.email,
      'uid': user.uid,
      'address': user.address
    };
    _dataController.add(dataAddress);
  }

  @override
  void dispose() {
    _loadingController.close();
    _enabledController.close();
    _dataController.close();
  }
}
