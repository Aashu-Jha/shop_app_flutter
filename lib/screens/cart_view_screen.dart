import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart' show Cart;
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/cart_item.dart';

class CartViewScreen extends StatelessWidget {
  static const routeName = 'cart_view';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final scaffold = ScaffoldMessenger.of(context);
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
                  Chip(label: Text('\$${cart.getTotalPrice().toStringAsFixed(2)}',
                    style: TextStyle(color: Theme.of(context).primaryTextTheme.headline6.color,),),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart, scaffold: scaffold),
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          Expanded(
              child: ListView.builder(
                itemCount: cart.getItemCount(),
                  itemBuilder: (context, i) =>
                    CartItem(
                      id: cart.items.values.toList()[i].id,
                      productID: cart.items.keys.toList()[i],
                      title: cart.items.values.toList()[i].title,
                      quantity: cart.items.values.toList()[i].quantity,
                      price: cart.items.values.toList()[i].price,
                    ),
              )
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
    @required this.scaffold,
  }) : super(key: key);

  final Cart cart;
  final ScaffoldMessengerState scaffold;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: (widget.cart.getTotalPrice() <= 0 || _isLoading == true) ? null : ()  async {
          setState(() {
            _isLoading = true;
          });
      try {
        await Provider.of<Orders>(context, listen: false).addOrder(widget.cart.items.values.toList(), widget.cart.getTotalPrice());
        widget.cart.clear();
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        widget.scaffold.showSnackBar(SnackBar(content: Text('Deleting Failed!')));
      }

    }, child: _isLoading ? Center(child: CircularProgressIndicator(strokeWidth: 3,)) : Text('Order Now'));
  }
}
