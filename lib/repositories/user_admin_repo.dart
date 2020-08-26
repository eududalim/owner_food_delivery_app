import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gerente_loja/models/user_admin_model.dart';

class UserAdminRepo {
  FirebaseUser _firebaseUser;

  UserAdminRepo() {
    FirebaseAuth.instance.currentUser().then((value) => _firebaseUser = value);
  }

  void _saveData(UserAdminModel user, uid) async {
    await Firestore.instance
        .collection('admins')
        .document(uid)
        .setData(user.toMap(uid));
  }

  Future<bool> createUser(UserAdminModel user) async {
    if (await _haveAccount(user.email, user.password)) {
      _saveData(user, _firebaseUser.uid);
      return true;
    } else {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: user.email, password: user.password)
          .then((value) {
        _firebaseUser = value.user;
        _saveData(user, _firebaseUser.uid);
        return true;
      }).catchError((e) {
        return false;
      });
      return false;
    }
  }

  Future<bool> _haveAccount(email, password) => FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        _firebaseUser = value.user;
        return true;
      }).catchError(() => false);

  Future<bool> signIn(email, password) async => await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        if (await isAdmin(value.user.uid)) {
          _firebaseUser = value.user;
          return true;
        } else
          return false;
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

  Future<void> setData(UserAdminModel user, uid) async =>
      await Firestore.instance
          .collection('admins')
          .document(uid)
          .setData(user.toMap(uid));

  Future<void> signOut() async => await FirebaseAuth.instance.signOut();
}
