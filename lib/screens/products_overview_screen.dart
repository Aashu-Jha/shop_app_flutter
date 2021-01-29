import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/products_grid.dart';

enum FilterOptions {
 all,
 onlyFavorites,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = 'products_overview_screen';

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var showFavoritesOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selected) {
              setState(() {
                if(selected == FilterOptions.all) {
                  showFavoritesOnly = false;
                }else if(selected == FilterOptions.onlyFavorites){
                  showFavoritesOnly = true;
                }
              });
            },
              itemBuilder: (_) => [
                PopupMenuItem(child: Text('Select All'), value: FilterOptions.all,),
                PopupMenuItem(child: Text('Only Favorite'), value: FilterOptions.onlyFavorites,),
              ]),
          Consumer<Cart>(
            builder: (_,cart,ch) => Badge(
              value: cart.getItemCount().toString(),
              child: ch,
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.shopping_cart_outlined),
            ),
          ),
        ],
      ),
      body: ProductsGrid(showFavoritesOnly),
    );
  }
}

