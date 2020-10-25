import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  void addItem(
    String productId,
    double price,
    String title,
  ) {
    _items.update(
      productId,
      (existingCartItem) => CartItem(
        id: existingCartItem.id,
        title: existingCartItem.title,
        price: existingCartItem.price,
        quantity: existingCartItem.quantity + 1,
      ),
      ifAbsent: () => CartItem(
        id: DateTime.now().toString(),
        title: title,
        price: price,
        quantity: 1,
      ),
    );

    notifyListeners();
  }

  void undoAddItem(productKey) {
    if (!_items.containsKey(productKey)) {
      return;
    }
    if (_items[productKey].quantity > 1) {
      _items.update(
          productKey,
          (value) => CartItem(
              id: value.id,
              title: value.title,
              quantity: value.quantity - 1,
              price: value.price));
                  print(items[productKey].quantity);

    } else if (_items[productKey].quantity <= 1) {
      _items.update(
          productKey,
          (value) => CartItem(
              id: value.id,
              title: value.title,
              quantity: value.quantity,
              price: value.price));
      _items.remove(productKey);
      print('hi');
    }
    // } else {
    //   _items.remove(productKey);
    // }
    notifyListeners();
  }

  double get totalAmount {
    double sum = 0;
    _items.forEach((key, item) {
      sum += item.price * item.quantity;
    });
    return sum;
  }

  void removeItem(productKey) {
    _items.remove(productKey);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
