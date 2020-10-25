import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import '../providers/products.dart';

enum FavouriteOptions {
  OnlyFavourite,
  ShowAll,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _favouriteOnly = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
        Provider.of<Products>(context).fetchAndSetProducts().then((_) {
          setState(() {
            _isLoading = false;
          });
        });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        drawerScrimColor: Colors.white,
        drawer: AppDrawer(),
        backgroundColor: Color(0xFF21BFBD),
        appBar: AppBar(
          actions: [
            PopupMenuButton(
              onSelected: (FavouriteOptions selectedOption) {
                setState(() {
                  if (selectedOption == FavouriteOptions.OnlyFavourite) {
                    _favouriteOnly = true;
                  } else {
                    _favouriteOnly = false;
                  }
                });
              },
              itemBuilder: (ctx) => [
                PopupMenuItem(
                    child: Text('Only Favourite'),
                    value: FavouriteOptions.OnlyFavourite),
                PopupMenuItem(
                    child: Text('Show All'), value: FavouriteOptions.ShowAll),
              ],
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
            ),
            Consumer<Cart>(
                builder: (ctx, cartItem, childd) => cartItem.itemCount == 0
                    ? childd
                    : Badge(
                        child: childd, value: cartItem.itemCount.toString()),
                child: IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                  ),
                  onPressed: () =>
                      Navigator.of(context).pushNamed(CartScreen.routeName),
                ))
          ],
          backgroundColor: Color(0xFF21BFBD),
          title: Text(
            'Dentist Shop',
            // ignore: deprecated_member_use
            style: Theme.of(context).appBarTheme.textTheme.title,
          ),
          bottom: TabBar(
            indicatorWeight: 0.000000000000000000000000000001,
            indicatorColor: Theme.of(context).primaryColor,
            tabs: [
              Tab(
                icon: Container(
                    height: 25,
                    child: Image.asset('assets/images/dentist-tools.png',
                        color: Colors.white)),
                child: Text(
                  'Tools',
                  // ignore: deprecated_member_use
                  style: Theme.of(context).textTheme.title,
                ),
              )
            ],
          ),
        ),
        body: ListView(padding: const EdgeInsets.only(top: 50), children: [
          Container(
            padding: const EdgeInsets.only(top: 20),
            height: MediaQuery.of(context).size.height - 203.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(75.0),
                topRight: Radius.circular(75.0),
              ),
            ),
            child: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_favouriteOnly),
          ),
        ]),
      ),
    );
  }
}
