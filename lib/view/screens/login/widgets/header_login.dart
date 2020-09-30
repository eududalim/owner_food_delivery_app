import 'package:flutter/material.dart';

class HeaderLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Icon(
        //   Icons.store,
        //   size: 100,
        //   color: Theme.of(context).primaryColor,
        // ),
        Image(
          image: AssetImage('assets/delivery-icon-secondary.png'),
          height: 90,
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'VEM DELIVERY',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              'App do Anunciante',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
            )
          ],
        )
      ],
    );
  }
}
