import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/address_bloc.dart';
import 'package:gerente_loja/view/screens/address/widgets/button_save_address.dart';
import 'package:gerente_loja/view/screens/address/widgets/header_address.dart';
import 'package:gerente_loja/view/screens/sign_up/widgets/header_sign_up.dart';
import 'package:gerente_loja/view/widgets/input_field.dart';

class AddressScreen extends StatelessWidget {
  final _addressBloc = AddressBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<bool>(
            initialData: false,
            stream: _addressBloc.outLoading,
            builder: (context, loading) {
              if (!loading.hasData) return Container();
              if (loading.data)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else
                return ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    HeaderAddress(),
                    SizedBox(height: 30),
                    InputField(
                      done: false,
                      hint: 'Rua',
                      obscure: false,
                      onChanged: _addressBloc.changeRua,
                      stream: _addressBloc.outRua,
                    ),
                    SizedBox(height: 20),
                    InputField(
                      done: false,
                      hint: 'Complemento',
                      obscure: false,
                      onChanged: _addressBloc.changeComplemento,
                      stream: _addressBloc.outComplemento,
                    ),
                    SizedBox(height: 20),
                    InputField(
                      done: false,
                      hint: 'Referencia',
                      obscure: false,
                      onChanged: _addressBloc.changeReferencia,
                      stream: _addressBloc.outReferencia,
                    ),
                    SizedBox(height: 20),
                    InputField(
                      done: false,
                      hint: 'Bairro',
                      obscure: false,
                      onChanged: _addressBloc.changeBairro,
                      stream: _addressBloc.outBairro,
                    ),
                    SizedBox(height: 20),
                    InputField(
                      done: false,
                      hint: 'Cidade',
                      obscure: false,
                      onChanged: _addressBloc.changeCidade,
                      stream: _addressBloc.outCidade,
                    ),
                    SizedBox(height: 20),
                    InputField(
                      done: false,
                      hint: 'Estado',
                      obscure: false,
                      onChanged: _addressBloc.changeEstado,
                      stream: _addressBloc.outEstado,
                    ),
                    SizedBox(height: 20),
                    ButtonSaveAddress(_addressBloc.saveAddress)
                  ],
                );
            }),
      ),
    );
  }
}
