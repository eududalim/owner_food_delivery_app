// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Organizando Orders', () async {
    String uid = '68UWBmeJItNANDMFkjQhaf3GPwn1';
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection('orders').getDocuments();

    querySnapshot.documents.map((doc) async {
      print(doc.documentID);
      await Firestore.instance
          .collection('admins')
          .document(uid)
          .collection('orders')
          .document(doc.documentID)
          .setData(doc.data);
    });

    print('Finish');
  });

  test('Teste de Cloud Functions', () async {
    final response = await CloudFunctions.instance
        .getHttpsCallable(functionName: 'helloWorld')
        .call();

    print(response.data);
  });
}
