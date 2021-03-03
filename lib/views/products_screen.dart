import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgeds/app_drawer.dart';
import '../providers/products.dart';
import '../widgeds/product_item.dart';
import '../utils/app_routes.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = productsData.items;
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar Produtos'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRoutes.PRODUCT_FORM,
              );
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: productsData.itensCount,
          itemBuilder: (ctx, index) => Column(
            children: <Widget>[
              ProductItem(products[index]),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
