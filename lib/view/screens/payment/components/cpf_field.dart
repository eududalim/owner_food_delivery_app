import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerente_loja/blocs/sign_up_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CpfField extends StatelessWidget {
  final SignUpBloc _signUpBloc = SignUpBloc();

  @override
  Widget build(BuildContext context) {
    final cpfMask = MaskTextInputFormatter(mask: '###.###.###-##');

    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'CPF',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                  hintText: '000.000.000-00', isDense: true),
              keyboardType: TextInputType.number,
              inputFormatters: [
                // WhitelistingTextInputFormatter.digitsOnly,
                cpfMask
              ],
              validator: (cpf) {
                if (cpf.isEmpty)
                  return 'Campo Obrigatório';
                else if (!CPFValidator.isValid(cpf)) return 'CPF Inválido';
                return null;
              },
              onSaved: _signUpBloc.saveCPF,
            )
          ],
        ),
      ),
    );
  }
}
