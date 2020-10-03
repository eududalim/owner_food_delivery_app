import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/account_bloc.dart';
import 'package:gerente_loja/blocs/address_bloc.dart';
import 'package:gerente_loja/blocs/login_bloc.dart';
import 'package:gerente_loja/models/user_admin_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class MyAccountTab extends StatefulWidget {
  @override
  _MyAccountTabState createState() => _MyAccountTabState();
}

class _MyAccountTabState extends State<MyAccountTab> {
  InputDecoration _buildDecoration(String label) {
    return InputDecoration(
        border: InputBorder.none,
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600]));
  }

  @override
  Widget build(BuildContext context) {
    final _loginBloc = BlocProvider.of<LoginBloc>(context);
    final _address = AddressBloc();
    final _fieldStyle = TextStyle(fontSize: 16);
    final _formKey = GlobalKey<FormState>();
    final _maskPhone = MaskTextInputFormatter(mask: '(##) #####-####');
    UserAdminModel _user = _loginBloc.userModel;
    AccountBloc _accountBloc = AccountBloc(_user);

    void saveData() async {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();

        bool success = await _accountBloc.saveData(_user.uid);

        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(success
              ? 'Dados salvos com sucesso!'
              : 'Erro ao atualizar dados'),
          backgroundColor: success
              ? Theme.of(context).primaryColor.withOpacity(0.7)
              : Colors.redAccent,
        ));
      }
    }

    return StreamBuilder<Map>(
        // initialData: _user.toMap(_user.uid),
        stream: _accountBloc.outData,
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return StreamBuilder<bool>(
                initialData: false,
                stream: _accountBloc.outEnabled,
                builder: (context, enabled) {
                  return Form(
                    key: _formKey,
                    child: ListView(padding: EdgeInsets.all(18), children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'MINHA CONTA',
                            style: TextStyle(
                                fontSize: 25,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600),
                          ),
                          FlatButton(
                              onPressed: _loginBloc.signOut,
                              padding: EdgeInsets.zero,
                              textColor: Colors.red,
                              child: Text(
                                'Sair',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              )),
                        ],
                      ),
                      SizedBox(height: 25),
                      TextFormField(
                        enabled: enabled.data,
                        initialValue: snapshot.data['name'],
                        style: _fieldStyle,
                        decoration: _buildDecoration("Nome"),
                        onSaved: _accountBloc.saveName,
                        validator: _accountBloc.validateName,
                      ),
                      TextFormField(
                        enabled: false,
                        initialValue: snapshot.data['email'],
                        style: _fieldStyle,
                        decoration: _buildDecoration("Email"),
                        onSaved: _accountBloc.saveEmail,
                        validator: _accountBloc.validateEmail,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      TextFormField(
                        enabled: enabled.data,
                        inputFormatters: [_maskPhone],
                        initialValue: snapshot.data['phone'],
                        style: _fieldStyle,
                        decoration: _buildDecoration("Telefone"),
                        onSaved: _accountBloc.savePhone,
                        validator: _accountBloc.validatePhone,
                        keyboardType: TextInputType.phone,
                      ),
                      TextFormField(
                        enabled: enabled.data,
                        initialValue: snapshot.data['titleStore'],
                        style: _fieldStyle,
                        decoration: _buildDecoration("Titulo comercial"),
                        onSaved: _accountBloc.saveTitleStore,
                        validator: _accountBloc.validateTitleStore,
                      ),

                      //ENDEREÇO///////////////////////////////////////////////
                      SizedBox(height: 20),
                      Divider(),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Divider(
                            color: Colors.grey,
                          ),
                          Text(
                            'ENDEREÇO',
                            style: _fieldStyle,
                          ),
                          Divider(
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      TextFormField(
                          enabled: enabled.data,
                          initialValue: snapshot.data['address'] == null
                              ? ''
                              : snapshot.data['address']['rua'],
                          style: _fieldStyle,
                          decoration: _buildDecoration("Rua"),
                          onSaved: _accountBloc.saveRua,
                          validator: _accountBloc.validate),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: TextFormField(
                              enabled: enabled.data,
                              initialValue: snapshot.data['address'] == null
                                  ? ''
                                  : snapshot.data['address']['bairro'],
                              style: _fieldStyle,
                              decoration: _buildDecoration("Bairro"),
                              onSaved: _accountBloc.saveBairro,
                              validator: _accountBloc.validate,
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: TextFormField(
                              enabled: enabled.data,
                              initialValue: snapshot.data['address'] == null
                                  ? ''
                                  : snapshot.data['address']['cidade'],
                              style: _fieldStyle,
                              decoration: _buildDecoration("Cidade"),
                              onSaved: _accountBloc.saveCidade,
                              validator: _accountBloc.validate,
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            child: TextFormField(
                              enabled: enabled.data,
                              initialValue: snapshot.data['address'] == null
                                  ? ''
                                  : snapshot.data['address']['estado'],
                              style: _fieldStyle,
                              decoration: _buildDecoration("Estado"),
                              onSaved: _accountBloc.saveEstado,
                              validator: _accountBloc.validate,
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        enabled: enabled.data,
                        initialValue: snapshot.data['address'] == null
                            ? ''
                            : snapshot.data['address']['complemento'],
                        style: _fieldStyle,
                        decoration: _buildDecoration("Complemento"),
                        onSaved: _accountBloc.saveComplemento,
                      ),
                      TextFormField(
                        enabled: enabled.data,
                        initialValue: snapshot.data['address'] == null
                            ? ''
                            : snapshot.data['address']['referencia'],
                        style: _fieldStyle,
                        decoration: _buildDecoration("Referência"),
                        onSaved: _accountBloc.saveReferencia,
                        validator: _accountBloc.validate,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          StreamBuilder<bool>(
                              initialData: false,
                              stream: _accountBloc.outLoading,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) if (snapshot.data)
                                  return Container(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(
                                          Theme.of(context).primaryColor),
                                    ),
                                  );
                                return FlatButton.icon(
                                  padding: EdgeInsets.zero,
                                  textColor: Colors.teal,
                                  onPressed: !enabled.data
                                      ? _accountBloc.enabledEdit
                                      : saveData,
                                  icon: enabled.data
                                      ? Icon(CupertinoIcons
                                          .check_mark_circled_solid)
                                      : Icon(CupertinoIcons.pencil),
                                  label: Text(
                                      enabled.data ? 'Concluir' : 'Editar'),
                                );
                              })
                        ],
                      ),
                    ]),
                  );
                });
          return Container();
        });
  }
}
