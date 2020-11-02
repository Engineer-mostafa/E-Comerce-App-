import 'package:Shop/providers/cart.dart' show Cart;
import 'package:Shop/providers/orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
    var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return Scaffold(
      backgroundColor: Color(0xFF21BFBD),
      appBar: AppBar(
        backgroundColor: Color(0xFF21BFBD),
        title: Text(
          'Cart',
          // ignore: deprecated_member_use
          style: Theme.of(context).textTheme.title,
        ),
        actions: [
          Consumer<Cart>(builder: (ctx, item, _) {
            return FlatButton(
                onPressed: (cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                cart.items.values.toList(),
                cart.totalAmount,
              );
              setState(() {
                _isLoading = false;
              });
              cart.clear();
            },
                child: _isLoading ? CircularProgressIndicator() : Text(
                  'Order Now',
                  style: TextStyle(color: Colors.white),
                ));
          })
        ],
      ),
      body: Consumer<Cart>(
        builder: (ctx, child, _) {
          return Column(
            children: [
              Card(
                elevation: 20,
                margin: const EdgeInsets.all(15),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(fontSize: 20),
                      ),
                      Chip(
                        label: Text(
                          '\$ ${cart.totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Color(0xFF21BFBD),
                      )
                    ],
                  ),
                ),
              ),
              cart.itemCount == 0
                  ? Container(
                      child: Center(
                        child: Text('No Items Added Yet'),
                      ),
                      padding: const EdgeInsets.only(top: 20),
                      height: MediaQuery.of(context).size.height - 180.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(75.0),
                        ),
                      ),
                    )
                  : Container(
                      child: ListView.builder(
                        itemCount: cart.items.length,
                        itemBuilder: (_, i) => CartItem(
                          cart.items.values.toList()[i].id,
                          cart.items.values.toList()[i].title,
                          cart.items.values.toList()[i].quantity,
                          cart.items.values.toList()[i].price,
                          cart.items.keys.toList()[i],
                        ),
                      ),
                      padding: const EdgeInsets.only(top: 20),
                      height: MediaQuery.of(context).size.height - 180.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(75.0),
                        ),
                      ),
                    )
            ],
          );
        },
      ),
    );
  }
}

