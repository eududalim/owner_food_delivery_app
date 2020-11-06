import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/product_bloc.dart';
import 'package:gerente_loja/models/user_admin_model.dart';
import 'package:gerente_loja/validators/product_validator.dart';
import 'package:gerente_loja/view/screens/product/widgets/images_widget.dart';

class ProductScreen extends StatefulWidget {
  final String categoryId;
  final DocumentSnapshot product;
  final UserAdminModel user;

  ProductScreen({this.categoryId, this.product, this.user});

  @override
  _ProductScreenState createState() =>
      _ProductScreenState(categoryId, product, user);
}

class _ProductScreenState extends State<ProductScreen> with ProductValidator {
  final ProductBloc _productBloc;
  final UserAdminModel user;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _ProductScreenState(String categoryId, DocumentSnapshot product, this.user)
      : _productBloc = ProductBloc(
            categoryId: categoryId, product: product, userAdminModel: user);

  @override
  Widget build(BuildContext context) {
    InputDecoration _buildDecoration(String label, {String hint}) {
      return InputDecoration(
          hintText: hint,
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[700]));
    }

    final _fieldStyle = TextStyle(fontSize: 16);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        title: StreamBuilder<bool>(
            stream: _productBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              return Text(snapshot.data ? "Editar Produto" : "Criar Produto");
            }),
        actions: <Widget>[
          StreamBuilder<bool>(
            stream: _productBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              if (snapshot.data)
                return StreamBuilder<bool>(
                    stream: _productBloc.outLoading,
                    initialData: false,
                    builder: (context, snapshot) {
                      return IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: snapshot.data
                            ? null
                            : () {
                                _productBloc.deleteProduct();
                                Navigator.pop(context);
                              },
                      );
                    });
              else
                return Container();
            },
          ),
          StreamBuilder<bool>(
              stream: _productBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IconButton(
                  icon: Icon(Icons.save),
                  onPressed: snapshot.data ? null : saveProduct,
                );
              }),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Form(
            key: _formKey,
            child: StreamBuilder<Map>(
                stream: _productBloc.outData,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  return ListView(
                    padding: EdgeInsets.all(16),
                    children: <Widget>[
                      Text(
                        "Imagens",
                        style: TextStyle(color: Colors.grey[700], fontSize: 12),
                      ),
                      ImagesWidget(
                        context: context,
                        initialValue: snapshot.data["images"],
                        onSaved: _productBloc.saveImages,
                        validator: validateImages,
                      ),
                      TextFormField(
                        initialValue: snapshot.data["title"],
                        style: _fieldStyle,
                        decoration: _buildDecoration("Título"),
                        onSaved: _productBloc.saveTitle,
                        validator: validateTitle,
                      ),
                      TextFormField(
                        initialValue: snapshot.data["description"],
                        style: _fieldStyle,
                        maxLines: 6,
                        decoration: _buildDecoration("Descrição"),
                        onSaved: _productBloc.saveDescription,
                        //validator: validateDescription,
                      ),
                      TextFormField(
                        initialValue:
                            snapshot.data["price"]?.toStringAsFixed(2),
                        style: _fieldStyle,
                        decoration:
                            _buildDecoration("Preço", hint: 'Exemplo: 3.50'),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        onSaved: _productBloc.savePrice,
                        validator: validatePrice,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      /*  Text(
                        "Tamanhos",
                        style: TextStyle(color: Colors.grey[700], fontSize: 12),
                      ),
                      ProductSizes(
                        context: context,
                        initialValue: snapshot.data["sizes"],
                        onSaved: _productBloc.saveSizes,
                        // ignore: missing_return
                        validator: (s) {
                          if (s.isEmpty) return "";
                        },
                      ) */
                    ],
                  );
                }),
          ),
          StreamBuilder<bool>(
              stream: _productBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IgnorePointer(
                  ignoring: !snapshot.data,
                  child: Container(
                    color: snapshot.data ? Colors.black54 : Colors.transparent,
                  ),
                );
              }),
        ],
      ),
    );
  }

  void saveProduct() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Salvando produto...",
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(minutes: 1),
        backgroundColor: Theme.of(context).primaryColor,
      ));

      bool success = await _productBloc.saveProduct();

      _scaffoldKey.currentState.removeCurrentSnackBar();

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          success ? "Produto salvo!" : "Erro ao salvar produto!",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: success ? Theme.of(context).primaryColor : Colors.red,
      ));
    }
  }
}
