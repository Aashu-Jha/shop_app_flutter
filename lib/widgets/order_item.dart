import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/orders.dart' as ord;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if(_expanded) Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            height: min(widget.order.products.length * 20.0 + 20, 180),
            child: ListView(
              children: widget.order.products.map((prod) =>
              Row(
                children: [
                  Text('${prod.title}', style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),),
                  Spacer(),
                  Text('${prod.quantity} x \$${prod.price}', style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey,
                  ),),
                ],
              ),
              ).toList(),
            ),
          )
        ],
      ),
    );
  }
}
