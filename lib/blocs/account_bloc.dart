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

  Map<String, dynamic> unsavedData;

  void saveTitleStore(String title) {
    unsavedData["titleStore"] = title;
  }

  void saveName(String name) {
    unsavedData["name"] = name;
  }

  void saveEmail(String email) {
    unsavedData["email"] = email;
  }

  void savePhone(String phone) {
    unsavedData["phone"] = phone;
  }

//implementar isso
  void saveAddress(Map address) {
    unsavedData["address"] = address;
  }

  Future<bool> saveData(String uid) async {
    _enabledController.add(false);
    _loadingController.add(true);

    await Firestore.instance
        .collection('admins')
        .document(uid)
        .updateData(unsavedData)
        .catchError((e) {
      _loadingController.add(false);
      return false;
    });

    _loadingController.add(false);
    return true;
  }

  AccountBloc(UserAdminModel user) {
    unsavedData = {
      'name': user.name,
      'titleStore': user.titleStore,
      'phone': user.phone,
      'email': user.email,
      'uid': user.uid
    };
    _dataController.add(unsavedData);
  }

  @override
  void dispose() {
    _loadingController.close();
    _enabledController.close();
    _dataController.close();
  }
}
