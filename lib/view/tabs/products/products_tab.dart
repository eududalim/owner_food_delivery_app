import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/models/user_admin_model.dart';
import 'package:gerente_loja/view/tabs/products/widgets/category_tile.dart';

class ProductsTab extends StatefulWidget {
  final UserAdminModel _user;
  ProductsTab(this._user);

  @override
  _ProductsTabState createState() => _ProductsTabState(_user);
}

class _ProductsTabState extends State<ProductsTab> {
  _ProductsTabState(this._user);
  UserAdminModel _user;

  // with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    //   super.build(context);

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
            return CategoryTile(snapshot.data.documents[index], _user);
          },
        );
      },
    );
  }

  //@override
  // bool get wantKeepAlive => true;
}
