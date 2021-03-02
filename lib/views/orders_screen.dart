import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgeds/app_drawer.dart';
import '../widgeds/order_widget.dart';
import '../providers/orders.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Orders orders = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Pedidos'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: orders.itensCount,
        itemBuilder: (ctx, index) => OrderWidget(orders.itens[index]),
      ),
    );
  }
}
