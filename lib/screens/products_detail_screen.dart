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
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(loadedProduct.title),
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(loadedProduct.title),
                background: Hero(
                  tag: loadedProduct.id,
                  child: Image(image: NetworkImage(loadedProduct.imageUrl),
                    height: 300,
                    width: double.infinity,
                  ),
                ),
              )
            ),
            SliverList(
                delegate: SliverChildListDelegate(
                  [
                    SizedBox(height: 10,),
                    Center(child: Text('\$ ${loadedProduct.price}')),
                    SizedBox(height: 10,),
                    Text('${loadedProduct.description}',
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 800,)
                  ]
                ),
            )
          ],
        ),
      ),
    );
  }
}
