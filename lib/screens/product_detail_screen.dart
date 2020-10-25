import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {

  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productDataArguments =
        ModalRoute.of(context).settings.arguments as Map; // is the id!
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productDataArguments['id']);
    return Scaffold(
      backgroundColor: Color(0xFF21BFBD),
      appBar: AppBar(
        backgroundColor: Color(0xFF21BFBD),
        title:
            // ignore: deprecated_member_use
            Text(loadedProduct.title, style: Theme.of(context).textTheme.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(children: [
              Container(
                margin: const EdgeInsets.only(top: 150),
                padding: const EdgeInsets.only(top: 20),
                height: MediaQuery.of(context).size.height - 180.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(75.0),
                    topRight: Radius.circular(75.0),
                  ),
                ),
              ),
              Positioned(
                top: 50,
                left: (MediaQuery.of(context).size.width / 2) - 100,
                child: Hero(
                  tag: productDataArguments['id'],
                  child: loadedProduct.imgFile == null ? Image.asset(loadedProduct.imgUrl) : Image.file(loadedProduct.imgFile
                  ),
                ),
                height: 200,
                width: 200,
              ),
              Positioned(
                top: (MediaQuery.of(context).size.height / 2) - 50,
                left: (MediaQuery.of(context).size.width / 2) - 70,
                child: Column(
                  children: [
                    Container(
                        alignment: Alignment.center,
                        child: Text(
                          '${loadedProduct.title}',
                          softWrap: true,
                        )),
                    SizedBox(height: 10),
                    Container(
                        alignment: Alignment.center,
                        child: Text(
                          '${loadedProduct.description}',
                          softWrap: true,
                        )),
                  ],
                ),
              )
            ]),
          ],
        ),
      ),
    );
  }
}
