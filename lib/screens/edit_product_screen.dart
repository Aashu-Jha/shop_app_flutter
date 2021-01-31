import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = 'edit_product_screen';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceNode = FocusNode();
  final _descriptionNode = FocusNode();

  @override
  void dispose() {
    _descriptionNode.dispose();
    _priceNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                  )
                ),
                textInputAction: TextInputAction.next,
                onSubmitted: (_) {
                  Focus.of(context).requestFocus(_priceNode);
                },
              ),
              TextField(
                decoration: InputDecoration(
                labelText: 'Price',
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                  )
                ),
                textInputAction: TextInputAction.next,
                focusNode: _priceNode,
                keyboardType: TextInputType.number,
                onSubmitted: (_) {
                  Focus.of(context).requestFocus(_descriptionNode);
                },
              ),
              TextField(
                decoration: InputDecoration(
                labelText: 'Description',
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                  )
                ),
                focusNode: _descriptionNode,
                maxLines: 3,
                keyboardType: TextInputType.multiline,
              ),

            ],
          ),
        ),
      ),
    );
  }
}
