import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/models/user_admin_model.dart';
import 'package:gerente_loja/view/screens/product/product_screen.dart';
import 'package:shimmer/shimmer.dart';

class CategoryTile extends StatelessWidget {
  final DocumentSnapshot category;
  final UserAdminModel _user;

  CategoryTile(this.category, this._user);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        // color: Colors.grey[100],
        elevation: 5,
        child: ExpansionTile(
          //Titulo da categoria

          title:
              /*  GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => EditCategoryDialog(
                          category: category,
                        ));
              },
              child:  */
              Text(
            category.documentID,
            style:
                TextStyle(color: Colors.grey[850], fontWeight: FontWeight.w600),
          ),
          children: <Widget>[
            // Busca os ids dos produtos em cada categoria

            StreamBuilder<QuerySnapshot>(
              stream: category.reference.collection("items").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();

                // Lista dos items expandidos

                return Column(
                    children: snapshot.data.documents.map((doc) {
                  return StreamBuilder<DocumentSnapshot>(
                    initialData: null,
                    //verifica se o item pertence ao usuario admin logado
                    stream: Firestore.instance
                        .collection('admins')
                        .document(_user.uid)
                        .collection('products')
                        .document(doc.documentID)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || !snapshot.data.exists) {
                        return Container();
                      }

                      if (snapshot.data.exists) {
                        return StreamBuilder<DocumentSnapshot>(
                            stream: Firestore.instance
                                .collection('products')
                                .document(doc.documentID)
                                .snapshots(),
                            builder: (context, product) {
                              if (!product.hasData)
                                return Container(
                                  width: 200,
                                  height: 25,
                                  margin: EdgeInsets.all(16),
                                  alignment: Alignment.centerLeft,
                                  child: Shimmer.fromColors(
                                      child: Container(
                                        color: Colors.white.withAlpha(50),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 4),
                                      ),
                                      baseColor: Colors.white,
                                      highlightColor: Colors.grey),
                                );

                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(product.data["images"][0]),
                                  backgroundColor: Theme.of(context)
                                      .primaryColor
                                      .withAlpha(50),
                                ),
                                title: Text(product.data["title"]),
                                trailing: Text(
                                    "R\$${product.data["price"].toStringAsFixed(2)}"),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ProductScreen(
                                            categoryId: category.documentID,
                                            product: product.data,
                                            user: _user,
                                          )));
                                },
                                onLongPress: () => showDialog(
                                    context: context,
                                    child: CupertinoAlertDialog(
                                      title: Text('Remover'),
                                      content:
                                          Text('Deseja remover este produto?'),
                                      actions: [
                                        CupertinoDialogAction(
                                            child: Text('Cancelar'),
                                            onPressed: () =>
                                                Navigator.pop(context)),
                                        CupertinoDialogAction(
                                            child: Text('Sim'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              doc.reference.delete();
                                              snapshot.data.reference.delete();
                                              product.data.reference.delete();
                                              return Scaffold.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Você removeu este produto')),
                                              );
                                            })
                                      ],
                                    )),
                              );
                            });
                      }

                      return Container();
                    },
                  );
                  //atraves do ids já buscados, agora realiza a busca do produto real
                }).toList());
              },
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
              title: Text("Adicionar"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProductScreen(
                          categoryId: category.documentID,
                          user: _user,
                        )));
              },
            )
          ],
        ),
      ),
    );
  }
}
