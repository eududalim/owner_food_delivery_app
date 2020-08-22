import 'dart:async';

class SignUpValidator {
  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains("@")) {
      sink.add(email);
    } else {
      sink.addError("Insira um e-mail válido");
    }
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length > 8) {
      sink.add(password);
    } else {
      sink.addError("Insira uma senha segura com pelo menos 8 caracteres");
    }
  });

  final validateName =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name.length > 6) {
      sink.add(name);
    } else {
      sink.addError("Insira nome completo!");
    }
  });

  final validateCpf =
      StreamTransformer<String, String>.fromHandlers(handleData: (cpf, sink) {
    if (cpf.length > 6) {
      sink.add(cpf);
    } else {
      sink.addError("Insira um CPF válido!");
    }
  });
}
