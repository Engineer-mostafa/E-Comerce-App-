
import './providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/orders.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (_) => Products(null, [],null),
            update: (_, auth, previousProduct) => Products(auth.token,
                previousProduct == null ? [] : previousProduct.items,auth.userid),
          ),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProxyProvider<Auth,Orders>(
            create:(ctx)=> Orders(null,[],null),
            update: (ctx,auth,previousOrders)=>Orders(auth.token,previousOrders == null ? []:previousOrders.orders,auth.userid),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, authData, _) {
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Dentist Shop',
                theme: ThemeData(
                  textTheme: ThemeData.light().textTheme.copyWith(
                      // ignore: deprecated_member_use
                      title: TextStyle(color: Colors.white)),
                  primaryColor: Color(0xFF21BFBD),
                  appBarTheme: AppBarTheme(
                      textTheme: ThemeData.light().textTheme.copyWith(
                          // ignore: deprecated_member_use
                          title: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      color: Color(0xFF21BFBD),
                      iconTheme: IconThemeData(
                        color: Colors.white,
                      )),
                  accentColor: Colors.deepOrange,
                  fontFamily: 'Lato',
                  iconTheme: IconThemeData(color: Colors.white),
                ),
                home: authData.isAuth
                  ? ProductsOverviewScreen()
                  : FutureBuilder(
                      future: authData.tryAutoLogin(),
                      builder: (ctx, authResultSnapshot) =>
                          authResultSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                    ),
                routes: {
                  ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                  CartScreen.routeName: (ctx) => CartScreen(),
                  OrdersScreen.routeName: (ctx) => OrdersScreen(),
                  UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
                  EditProductScreen.routeName: (ctx) => EditProductScreen(),
                });
          },
        ));
  }
}
