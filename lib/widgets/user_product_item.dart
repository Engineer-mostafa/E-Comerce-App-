import 'dart:io';

import 'package:Shop/providers/products.dart';
import 'package:Shop/screens/edit_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final File imgFile;
  final bool isFile;

  UserProductItem(this.title, this.imageUrl, this.id, this.imgFile, this.isFile);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        child: Container(child: isFile != true ?Image.asset(imageUrl):Image.file(imgFile)),
        backgroundColor: Colors.white,
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName,
                    arguments: {'title': 'Add Product', 'id': id});
              },
              color: Color(0xFF21BFBD),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      title: Text('Are You Sure?',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      content: Text(
                        'Do you want to remove the item from the cart?',
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('No'),
                          onPressed: () {
                            Navigator.of(ctx).pop(false);
                          },
                        ),
                        FlatButton(
                          child: Text('Yes'),
                          onPressed: () {
                            Navigator.of(ctx).pop(true);
                          },
                        ),
                      ],
                    );
                  }).then(
                (value) => value == true
                    ? Provider.of<Products>(context, listen: false)
                        .deletProduct(id)
                    : () {},
              ),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
