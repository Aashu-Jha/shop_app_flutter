import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

class CartViewScreen extends StatelessWidget {
  static const routeName = 'cart_view';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Cart',
        ),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Text('Total:',
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).textTheme.headline5.color,
                    ),
                  ),
                  Spacer(),
                  Chip(label: Text('\$${cart.getTotalPrice()}',
                    style: TextStyle(color: Theme.of(context).primaryTextTheme.headline6.color,),),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  TextButton(onPressed: () {}, child: Text('Order Now')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
