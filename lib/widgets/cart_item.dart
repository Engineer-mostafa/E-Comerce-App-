import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productKey;
  final String title;
  final int quantity;
  final double price;
  CartItem(this.id, this.title, this.quantity, this.price, this.productKey);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (direction) {
        return showDialog(context: context, builder: (ctx) {
          return AlertDialog(
            title: Text('Are You Sure?',style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),

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
        });
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productKey);
      },
      direction: DismissDirection.endToStart,
      key: ValueKey(id),
      background: Container(
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
        color: Theme.of(context).errorColor,
      ),
      child: Card(
        elevation: 3,
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: FittedBox(
                child: Text(
                  '${price.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            radius: 20,
          ),
          title: Text(title),
          subtitle: Text('Total: \$ ${(price * quantity)}'),
          trailing: Text('${(quantity)} X'),
        ),
      ),
    );
  }
}
