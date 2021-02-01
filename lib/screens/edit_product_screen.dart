import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = 'edit_product_screen';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceNode = FocusNode();
  final _descriptionNode = FocusNode();
  final _imageUrlNode = FocusNode();
  final _imageUrlController = TextEditingController();
  
  @override
  void initState() {
    _imageUrlNode.addListener(_updateImageFocusNode);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlNode.removeListener(_updateImageFocusNode);
    _descriptionNode.dispose();
    _priceNode.dispose();
    _imageUrlNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImageFocusNode() {
    if(!_imageUrlNode.hasFocus) {
      setState(() {
        //screen will update itself
      });
    }
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8 , right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter a URL')
                        : FittedBox(
                            fit: BoxFit.cover,
                            child: Image.network(_imageUrlController.text)),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _imageUrlController,
                      decoration: InputDecoration(labelText: 'Image URL'),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.url,
                      focusNode: _imageUrlNode,
                    ),
                  ),
                  
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
