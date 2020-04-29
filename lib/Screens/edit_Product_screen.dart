import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName='/editproduct';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceNode=FocusNode();
  final _descriptionNode=FocusNode();
  @override
  void dispose() {
    _priceNode.dispose();
    _descriptionNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: "Title"),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(_priceNode);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Price"),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceNode,
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(_descriptionNode);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Description"),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                focusNode: _descriptionNode,

              )
            ],
          ),
        ),
      ),
    );
  }
}
