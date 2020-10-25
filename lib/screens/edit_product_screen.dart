import 'dart:io';
import 'package:Shop/providers/product.dart';
import 'package:Shop/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  File _image;

  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imgUrl: '',
    imgFile: null,
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
    'imgFile': File,
  };

  var _isInit = true;
  var _isLoaded = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final argData = ModalRoute.of(context).settings.arguments as Map;
      if (argData['id'] != null) {
        _editedProduct = Provider.of<Products>(context, listen: false)
            .findById(argData['id']);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': _editedProduct.imgUrl,
          'imgFile': _editedProduct.imgFile,
        };
        _image = _initValues['imgFile'];
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  final picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _saveForm() async {
    if (!_form.currentState.validate()) return;
    _form.currentState.save();
    setState(() {
      _isLoaded = true;
    });
    if (_editedProduct.id != null) {
      _editedProduct.imgFile = _image;
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      setState(() {
        _isLoaded = false;
      });
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {}
      // finally {
      //   setState(() {
      //     _isLoaded = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isLoaded = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final argData = ModalRoute.of(context).settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
        backgroundColor: Color(0xFF21BFBD),
        title: Text(
          argData['title'],
        ),
      ),
      body: _isLoaded
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _initValues['title'],
                        // ignore: missing_return
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a title';
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Title',
                        ),
                        textInputAction: TextInputAction.next,
                        onSaved: (value) {
                          _editedProduct = Product(
                              title: value,
                              price: _editedProduct.price,
                              description: _editedProduct.description,
                              imgUrl: _editedProduct.imgUrl,
                              id: _editedProduct.id,
                              isFavourite: _editedProduct.isFavourite);
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        // ignore: missing_return
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a price';
                          } else if (double.tryParse(value) == null) {
                            return 'Please Enter a Valid Number';
                          } else if (double.parse(value) <= 0) {
                            return 'Please Enter a Valid Number > 0';
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Price',
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          _editedProduct = Product(
                              title: _editedProduct.title,
                              price: double.parse(value),
                              description: _editedProduct.description,
                              imgUrl: _editedProduct.imgUrl,
                              id: _editedProduct.id,
                              isFavourite: _editedProduct.isFavourite);
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        // ignore: missing_return
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a description';
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Description',
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        onSaved: (value) {
                          _editedProduct = Product(
                              title: _editedProduct.title,
                              price: _editedProduct.price,
                              description: value,
                              imgUrl: _editedProduct.imgUrl,
                              id: _editedProduct.id,
                              isFavourite: _editedProduct.isFavourite,
                              imgFile: _image);
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (_image != null)
                            Container(
                                height: 100,
                                width: 100,
                                child: Image.file(_image)),
                          if (_initValues['imageUrl'].toString().isNotEmpty)
                            Container(
                                height: 100,
                                width: 100,
                                child: Image.asset(_initValues['imageUrl'])),
                          if (_initValues['imageUrl'].toString().isEmpty &&
                              _initValues['imgFile'].toString().length < 10 &&
                              _image == null)
                            Text(
                              'Choose Image Of The Tool',
                              style: TextStyle(color: Colors.grey),
                            ),
                          Container(
                            height: 100,
                            width: 100,
                            child: IconButton(
                                color: Theme.of(context).primaryColor,
                                icon: Icon(Icons.add_a_photo),
                                onPressed: () {
                                  getImage();
                                }),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}
