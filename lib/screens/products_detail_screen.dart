import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';

class ProductsDetailScreen extends StatelessWidget {
  static const routeName = 'products_detail_screen';

  @override
  Widget build(BuildContext context) {
    final productID = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<Products>(context, listen: false).findById(productID);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              Hero(
                tag: loadedProduct.id,
                child: Image(image: NetworkImage(loadedProduct.imageUrl),
                  height: 300,
                  width: double.infinity,
                ),
              ),
              SizedBox(height: 10,),
              Text('\$ ${loadedProduct.price}'),
              SizedBox(height: 10,),
              Text('${loadedProduct.description}',
               textAlign: TextAlign.center,
               softWrap: true,
               style: TextStyle(
                 fontSize: 20,
                 fontWeight: FontWeight.w500,
               ),)
            ],
          ),
        ),
      ),
    );
  }
}
