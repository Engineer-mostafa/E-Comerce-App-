import 'package:Shop/providers/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatefulWidget {
  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Product>(context);
    final cartData = Provider.of<Cart>(context, listen: false);
    void startAddNewToCart(BuildContext ctx) {
      showModalBottomSheet(
        isScrollControlled: true,
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              width: 80,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 90,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            'How Many Items ?',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Consumer<Cart>(
                                builder: (ctx, item, child) {
                                  return cartData
                                              .items[productData.id].quantity ==
                                          null
                                      ? Text('Quantity: 0 ')
                                      : Text(
                                          'Quantity: ${cartData.items[productData.id].quantity} ');
                                },
                              ),
                              Container(
                                  child: Row(
                                children: [
                                  Consumer<Cart>(builder: (_, child, d) {
                                    return Container(
                                      child: IconButton(
                                        onPressed: () => cartData
                                                    .items[productData.id]
                                                    .quantity ==
                                                1
                                            ? () {}
                                            : cartData
                                                .undoAddItem(productData.id),
                                        icon: Text('-',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    );
                                  }),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: 2,
                                    child: Text(
                                      '|',
                                      style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.w100,
                                          color: Colors.grey),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Consumer<Cart>(builder: (_, child, d) {
                                    return Container(
                                      child: IconButton(
                                        onPressed: () => cartData.addItem(
                                            productData.id,
                                            productData.price,
                                            productData.title),
                                        icon: Text('+',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    );
                                  }),
                                ],
                              )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            behavior: HitTestBehavior.opaque,
          );
        },
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: Hero(
          tag: productData.id,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                  arguments: {'id': productData.id, 'img': productData.imgUrl});
            },
            child: productData.imgFile == null
                ? Image.asset(productData.imgUrl)
                : Image.file(productData.imgFile),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              icon: Icon(
                product.isFavourite ? Icons.favorite : Icons.favorite_border,
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {
                product.toggleFavoutie();
              },
            ),
          ),
          title: Text(
            productData.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              cartData.addItem(
                  productData.id, productData.price, productData.title);

              startAddNewToCart(context);
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
