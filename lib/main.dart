import 'package:flutter/material.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_view_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/products_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/user_products_screen.dart';
import 'providers/products_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => Auth()),
        // ignore: missing_required_param
        ChangeNotifierProxyProvider<Auth, Products>(
            update: (ctx, auth, previousProducts) => Products(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.items,
            ),),
        ChangeNotifierProvider(
            create: (context) => Cart()),
        // ignore: missing_required_param
        ChangeNotifierProxyProvider<Auth, Orders>(
            update: (ctx, auth, previousOrders) => Orders(
              auth.token,
              previousOrders == null ? [] : previousOrders.orders,
            )
        ),
      ],
      child: Consumer<Auth>(builder: (ctx, auth, _) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.deepPurple[200],
          fontFamily: 'Lato',
        ),
        home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
        routes: {
          // AuthScreen.routeName : (context) => AuthScreen(),
          ProductsOverviewScreen.routeName : (context) => ProductsOverviewScreen(),
          ProductsDetailScreen.routeName : (context) => ProductsDetailScreen(),
          CartViewScreen.routeName : (context) => CartViewScreen(),
          OrdersScreen.routeName : (context) => OrdersScreen(),
          UserProductsScreen.routeName : (context) => UserProductsScreen(),
          EditProductScreen.routeName : (context) => EditProductScreen(),
        },)
      ),
    );
  }
}


