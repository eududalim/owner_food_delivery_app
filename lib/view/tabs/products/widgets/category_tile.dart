import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/view/screens/product/product_screen.dart';
import 'package:gerente_loja/view/screens/home/widgets/edit_category_dialog.dart';

class CategoryTile extends StatelessWidget {
  final DocumentSnapshot category;

  CategoryTile(this.category);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          leading: GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => EditCategoryDialog(
                        category: category,
                      ));
            },
            child: CircleAvatar(
              // backgroundImage: NetworkImage(category.data["icon"]),
              backgroundColor: Colors.pinkAccent,
            ),
          ),

          //Titulo da categoria

          title: Text(
            category.documentID,
            style:
                TextStyle(color: Colors.grey[850], fontWeight: FontWeight.w600),
          ),
          children: <Widget>[
            // Busca os ids dos produtos em cada categoria

            FutureBuilder<QuerySnapshot>(
              future: category.reference.collection("items").getDocuments(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();

                // Lista dos items expandidos

                return Column(
                    children: snapshot.data.documents.map((doc) {
                  //atraves do ids já buscados, agora realiza a busca do produto real

                  return FutureBuilder<DocumentSnapshot>(
                      future: Firestore.instance
                          .collection('products')
                          .document(doc.documentID)
                          .get(),
                      builder: (context, product) {
                        if (!product.hasData) return Container();
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(product.data["imgUrl"]),
                          ),
                          title: Text(product.data["title"]),
                          trailing: Text(
                              "R\$${product.data["price"].toStringAsFixed(2)}"),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProductScreen(
                                      categoryId: category.documentID,
                                      product: product.data,
                                    )));
                          },
                        );
                      });
                }).toList()
                    /* ..add(FutureBuilder<DocumentSnapshot>(
                        future: null,
                        builder: (context, snapshot) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Icon(
                                Icons.add,
                                color: Colors.pinkAccent,
                              ),
                            ),
                            title: Text("Adicionar"),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ProductScreen(
                                        categoryId: category.documentID,
                                      )));
                            },
                          );
                        })), */
                    );
              },
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.transparent.withAlpha(10),
                child: Icon(
                  Icons.add,
                ),
              ),
              title: Text("Adicionar"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProductScreen(
                          categoryId: category.documentID,
                        )));
              },
            )
          ],
        ),
      ),
    );
  }
}
