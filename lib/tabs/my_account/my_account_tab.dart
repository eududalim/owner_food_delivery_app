import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'account_tile.dart';

class MyAccountTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: null,
        builder: (context, snapshot) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return AccountTile();
            },
          );
        });
  }
}
