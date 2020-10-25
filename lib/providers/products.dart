import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Syringe-Scaller',
    //   description: 'A Good Syringe-Scaller',
    //   price: 29.99,
    //   imgUrl: 'assets/images/16.png',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Dentist Box',
    //   description: 'A Large Box For You',
    //   price: 59.99,
    //   imgUrl: 'assets/images/17.png',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Contra',
    //   description: 'We Have a Good Material',
    //   price: 19.99,
    //   imgUrl: 'assets/images/18.png',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'Dentist Hook',
    //   description: 'We Have All Colors DT',
    //   price: 49.99,
    //   imgUrl: 'assets/images/19.png',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((element) => element.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> deletProduct(String id) async {
    final url = 'https://dental-tools.firebaseio.com/products/$id.json';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }

  Future<void> fetchAndSetProducts() async {
    const url = 'https://dental-tools.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData != null) {
        final List<Product> loadedProducts = [];
        extractedData.forEach((prodId, prodData) {
          loadedProducts.add(Product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              price: prodData['price'],
              isFavourite: prodData['isFavourite'],
              imgUrl: prodData['img'],
              imgFile: File(prodData['imgFile']
                  .toString()
                  .substring(7, prodData['imgFile'].toString().length - 1))));
        });
        _items = loadedProducts;
        notifyListeners();
      } else {
        _items = [];
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    const url = 'https://dental-tools.firebaseio.com/products.json';
    try {
      final respose = await http.post(url,
          body: json.encode({
            'id': product.id,
            'description': product.description,
            'title': product.title,
            'price': product.price,
            'isFavourite': product.isFavourite,
            'img': product.imgUrl,
            'imgFile': product.imgFile.toString()
          }));

      final newProduct = Product(
        id: json.decode(respose.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imgUrl: product.imgUrl,
        imgFile: product.imgFile,
      );

      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = 'https://dental-tools.firebaseio.com/products/$id.json';
      await http.patch(url,
          body: json.encode({
            'description': newProduct.description,
            'title': newProduct.title,
            'price': newProduct.price,
            'img': newProduct.imgUrl,
            'imgFile': newProduct.imgFile.toString()
          }));

      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }
}
