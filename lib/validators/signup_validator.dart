import 'dart:async';

class SignUpValidator {
  final validateName =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name.length > 6) {
      sink.add(name);
    } else {
      sink.addError("Insira nome completo!");
    }
  });

  final validateNameStore =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name.length > 5) {
      sink.add(name);
    } else {
      sink.addError("Insira nome comercial completo completo!");
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
