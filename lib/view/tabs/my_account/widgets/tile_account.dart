import 'package:flutter/material.dart';

class TileAccount extends StatelessWidget {
  final String labelTitle;

  final String dataUser;

  const TileAccount({
    Key key,
    @required this.labelTitle,
    @required this.dataUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelTitle,
          style:
              TextStyle(color: Colors.grey[200], fontWeight: FontWeight.w100),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
          child: Text(
            dataUser,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
