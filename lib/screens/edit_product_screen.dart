import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = 'edit_product_screen';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _form = GlobalKey<FormState>();
  final _priceNode = FocusNode();
  final _descriptionNode = FocusNode();
  final _imageUrlNode = FocusNode();
  final _imageUrlController = TextEditingController();  //controller for imageUrl to use for previewing image
  var _editedProduct = Product(id: null, title: '', description: '', price: 0, imageUrl: ''); //a blank product object
  
  @override
  void initState() {
    //whenever the _updateImageFocusNode changes it will listen the changes, it is generally using for imagePreview
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

  // when the image is empty it will set the state to show empty preview
  void _updateImageFocusNode() {
    if(!_imageUrlNode.hasFocus) {
      setState(() {
        //screen will update itself
      });
    }
  }

  //to save the state of form
  void _saveForm() {
    _form.currentState.save();
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
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                  )
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  //when user pressed next in keyboard the focus will set to _pricedNode point
                  Focus.of(context).requestFocus(_priceNode);
                },
                onSaved: (value) {
                  //we have to change the whole object because we have declared the class variables as final
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      title: value,
                      description: _editedProduct.description,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl);
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                labelText: 'Price',
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                  )
                ),
                textInputAction: TextInputAction.next,
                focusNode: _priceNode,
                keyboardType: TextInputType.number,
                onFieldSubmitted: (_) {
                  Focus.of(context).requestFocus(_descriptionNode);
                },
                onSaved: (value) {
                  //we have to change the whole object because we have declared the class variables as final
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      description: _editedProduct.description,
                      price: double.parse(value),
                      imageUrl: _editedProduct.imageUrl);
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                labelText: 'Description',
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                  )
                ),
                focusNode: _descriptionNode,
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                onSaved: (value) {
                  //we have to change the whole object because we have declared the class variables as final
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      description: value,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl);
                },
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
                    child: TextFormField(
                      controller: _imageUrlController,
                      decoration: InputDecoration(labelText: 'Image URL'),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.url,
                      focusNode: _imageUrlNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (value) {
                        //we have to change the whole object because we have declared the class variables as final
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: value);
                      },
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
