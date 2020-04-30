import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop/Models/Providers/Product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/editproduct';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceNode = FocusNode();
  final _descriptionNode = FocusNode();
  final _imageViewController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _editedProduct = Product(
      id: null, title: null, description: null, imageUrl: null, price: null);

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_showImagePreview);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_showImagePreview);
    _priceNode.dispose();
    _descriptionNode.dispose();
    _imageViewController.dispose();
    super.dispose();
  }

  void _showImagePreview() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    final _isVaild = _formKey.currentState.validate();
    if (!_isVaild) {
      return;
    }
    _formKey.currentState.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: "Title"),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter the Title';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      id: null,
                      title: value,
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                      price: _editedProduct.price);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Price"),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceNode,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter the Price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please Enter a Valid Number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a number greater then 0';
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      id: null,
                      title: _editedProduct.title,
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                      price: double.parse(value));
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Description"),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                focusNode: _descriptionNode,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter the Description';
                  }
                  if (value.length < 10) {
                    return 'Should be atleast 10 char long';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      id: null,
                      title: _editedProduct.title,
                      description: value,
                      imageUrl: _editedProduct.imageUrl,
                      price: _editedProduct.price);
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageViewController.text.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 35),
                            child: Text(
                              'Enter the URL',
                              textAlign: TextAlign.center,
                            ),
                          )
                        : FittedBox(
                            child: Image.network(
                              _imageViewController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image Url'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageViewController,
                      focusNode: _imageUrlFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter the ImageURL';
                        } 
                        if(!value.startsWith('http') && !value.startsWith('https')){
                          return 'Enter valid Url';
                        }
                          return null;
                        
                      },
                      onFieldSubmitted: (_) => _saveForm,
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: null,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            imageUrl: value,
                            price: _editedProduct.price);
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
