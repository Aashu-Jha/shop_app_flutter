import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String title;
  final String productID;
  final String id;
  final double price;
  final int quantity;


  CartItem({this.title,this.productID, this.id, this.price, this.quantity});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete,
          color: Colors.white,
          size: 30.0,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productID);
      },
      confirmDismiss: (direction) {
        return showDialog(context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you Sure'),
            content: Text('Do you want to remove this item?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: Text('No'),
              ),
            ],
          )
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: ListTile(
          leading: Padding(
            padding: const EdgeInsets.all(5.0),
            child: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(4),
                  child: FittedBox(child: Text('\$$price'))),
            ),
          ),
          title: Text(title),
          subtitle: Text('\$${price * quantity}'),
          trailing: Text('$quantity x'),
        ),
      ),
    );
  }
}
