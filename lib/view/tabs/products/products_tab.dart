import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/login_bloc.dart';
import 'package:gerente_loja/view/screens/payment/payment_screen.dart';
import 'package:gerente_loja/view/tabs/products/widgets/category_tile.dart';

class ProductsTab extends StatefulWidget {
  @override
  _ProductsTabState createState() => _ProductsTabState();
}

class _ProductsTabState extends State<ProductsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final _loginBloc = BlocProvider.of<LoginBloc>(context);

    return StreamBuilder<bool>(
        stream: _loginBloc.isPay,
        initialData: true,
        builder: (context, snapshot) {
          if (!snapshot.data) {
            return Container(
              color: Colors.black26,
              child: CupertinoAlertDialog(
                title: Text('Pagamento pendente!'),
                actions: [
                  FlatButton(
                    textColor: Colors.red,
                    child: Text('Sair'),
                    onPressed: () {
                      _loginBloc.signOut();
                    },
                  ),
                  FlatButton(
                    textColor: Theme.of(context).primaryColorDark,
                    child: Text('Realizar pagamento'),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PaymentScreen(),
                      ));
                    },
                  )
                ],
              ),
            );
          }

          return StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection("category").snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                );
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return CategoryTile(
                      snapshot.data.documents[index], _loginBloc.userModel);
                },
              );
            },
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}
