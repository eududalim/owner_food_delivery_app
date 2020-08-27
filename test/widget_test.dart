// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:gerente_loja/models/user_admin_model.dart';
import 'package:gerente_loja/repositories/user_admin_repo.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final _repoAdmin = UserAdminRepo();
  final _user = UserAdminModel(
      name: 'eduarda lima',
      nameStore: 'loja da duda',
      cpf: '0021516220',
      email: 'teste@teste.com',
      password: '12345678');

  test(
      'Deve criar um usuario no firebase e salvar seus dados no Banco de Dados',
      () async {
    expect(await _repoAdmin.createUser(_user), true);
  });
}
