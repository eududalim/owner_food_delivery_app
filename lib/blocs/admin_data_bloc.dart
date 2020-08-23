import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class AdminDataBloc extends BlocBase {
  @override
  void dispose() {
    _dataController.close();
  }

  AdminDataBloc() {
    FirebaseAuth.instance.currentUser().then((value) {
      if (value != null) _listenData(value.uid);
      _firebaseUser = value;
    }).catchError((e) {
      print('error ' + e.toString());
    });
  }

  final _dataController = BehaviorSubject<Map<String, dynamic>>();
  FirebaseUser _firebaseUser;

  Stream<Map> get outAdminData => _dataController.stream;

  void _listenData(uid) {
    if (uid == null) {
      return;
    }
    //String adminId = _user.uid;
    Firestore.instance.collection('admins').document(uid).get().then((value) {
      _dataController.add(value.data);
    });
  }

  void setData(Map<String, dynamic> data) {
    Firestore.instance
        .collection('admins')
        .document(_firebaseUser.uid)
        .setData(data);
  }
}
