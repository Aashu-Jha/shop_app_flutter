import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/cart_view_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/products_grid.dart';

enum FilterOptions {
 all,
 onlyFavorites,
}

class ProductsOverviewScreen extends StatefulWidget {
  // static const routeName = 'products_overview_screen';

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showFavoritesOnly = false;
  var _isInit = true;
  bool _isLoading = false;

  // @override
  // void initState() {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   //To fetch data before app starts fully
  //   //Provider will not work without wrapping in Future class as it takes a little time.
  //   Future.delayed(Duration.zero).then((_) {
  //     Provider.of<Products>(context, listen: false).fetchAndSetProducts().then((_) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //     });
  //   });
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context, listen: false).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }


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
                  _showFavoritesOnly = false;
                }else if(selected == FilterOptions.onlyFavorites){
                  _showFavoritesOnly = true;
                }
              });
            },
              itemBuilder: (_) => [
                PopupMenuItem(child: Text('Show All'), value: FilterOptions.all,),
                PopupMenuItem(child: Text('Only Favorite'), value: FilterOptions.onlyFavorites,),
              ]),
          Consumer<Cart>(
            builder: (_,cart,ch) => Badge(
              value: cart.getItemCount().toString(),
              child: ch,
            ),
            child: IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                Navigator.pushNamed(context, CartViewScreen.routeName);
              },
              icon: Icon(Icons.shopping_cart_outlined),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading ? Center(child: CircularProgressIndicator()) : ProductsGrid(_showFavoritesOnly),
    );
  }
}

