import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gerente_loja/blocs/orders_bloc.dart';

class CustomFloatingButton extends StatelessWidget {
  const CustomFloatingButton(this._page, this._ordersBloc);

  final int _page;
  final OrdersBloc _ordersBloc;

  @override
  Widget build(BuildContext context) {
    switch (_page) {
      case 0:
        return SpeedDial(
          child: Icon(Icons.sort),
          backgroundColor: Theme.of(context).primaryColorDark,
          overlayOpacity: 0.4,
          overlayColor: Colors.black,
          children: [
            SpeedDialChild(
                child: Icon(
                  Icons.arrow_downward,
                  color: Theme.of(context).primaryColorDark,
                ),
                backgroundColor: Colors.white,
                label: "Concluídos Abaixo",
                labelStyle: TextStyle(fontSize: 14),
                onTap: () {
                  _ordersBloc.setOrderCriteria(SortCriteria.READY_LAST);
                }),
            SpeedDialChild(
                child: Icon(
                  Icons.arrow_upward,
                  color: Theme.of(context).primaryColorDark,
                ),
                backgroundColor: Colors.white,
                label: "Concluídos Acima",
                labelStyle: TextStyle(fontSize: 14),
                onTap: () {
                  _ordersBloc.setOrderCriteria(SortCriteria.READY_FIRST);
                })
          ],
        );
      // case 1:
      //   return FloatingActionButton(
      //     child: Icon(Icons.refresh),
      //     backgroundColor: Theme.of(context).primaryColorDark,
      //     onPressed: () {
      //       //   showDialog(
      //       //       context: context, builder: (context) => EditCategoryDialog());
      //     },
      //   );
      default:
        return Container();
    }
  }
}
