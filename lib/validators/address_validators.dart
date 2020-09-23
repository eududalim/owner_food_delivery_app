import 'dart:async';

class AddressValidators {
  final validateRua =
      StreamTransformer<String, String>.fromHandlers(handleData: (rua, sink) {
    if (rua.length > 6 && rua.contains(' ')) {
      sink.add(rua);
    } else {
      sink.addError("Insira uma rua válida");
    }
  });

  final validateBairro = StreamTransformer<String, String>.fromHandlers(
      handleData: (bairro, sink) {
    if (bairro.length > 4) {
      sink.add(bairro);
    } else {
      sink.addError("Insira um bairro válido");
    }
  });

  final validateCidade = StreamTransformer<String, String>.fromHandlers(
      handleData: (cidade, sink) {
    if (cidade.length > 3) {
      sink.add(cidade);
    } else {
      sink.addError("Insira uma cidade válida");
    }
  });

  final validateEstado = StreamTransformer<String, String>.fromHandlers(
      handleData: (estado, sink) {
    if (estado.length > 4 && !estado.contains(' ')) {
      sink.add(estado);
    } else {
      sink.addError("Insira um estado válido");
    }
  });

  final validateReferencia = StreamTransformer<String, String>.fromHandlers(
      handleData: (referencia, sink) {
    if (referencia.length > 4 && referencia.contains(' ')) {
      sink.add(referencia);
    } else {
      sink.addError("Informe um ponto de referência");
    }
  });
}
