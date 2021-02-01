import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = 'user_products_screen';
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Products'),
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: () {
            Navigator.of(context).pushNamed(EditProductScreen.routeName);
          }),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal : 12.0, vertical: 6.0),
        child: ListView.builder(
          itemCount: productData.items.length,
            itemBuilder: (ctx, i) => Column(
              children: [
                UserProductItem(
                  title: productData.items[i].title,
                  id: productData.items[i].id,
                  imageUrl: productData.items[i].imageUrl,
                ),
                Divider(),
              ],
            )),
      ),
    );
  }
}
