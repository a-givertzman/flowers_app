import 'package:flowers_app/domain/purchase/purchase_product.dart';
import 'package:flowers_app/infrastructure/datasource/data_source.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flowers_app/presentation/product/widgets/product_body.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  final PurchaseProduct product;
  final DataSource dataSource;
  const ProductPage({
    Key? key,
    required this.product,
    required this.dataSource,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${product['product/name']}',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: const <Widget>[
          // UncompletedSwitch(),
        ],
        automaticallyImplyLeading: false,
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     //TODO FloatingActionButton action to be implemented
      //     throw Exception('FloatingActionButton action to be implemented');
      //     // AutoRouter.of(context).push(NoteFormPageRoute(note: null));
      //   },
      //   child: const Icon(Icons.add),
      // ),
      body: ProductBody(
        purchaseProduct: product,//PurchaseProduct(
          // id: product.id,
          // remote: dataSource.dataSet('purchase_content')
          //   .withParams(
          //     ApiParams(
          //       where: [{'operator': 'where', 'field': 'purchase/id', 'cond': '=', 'value': id}]
          //     )
          //   ),
        // ), 
      ),
    );
  }
}
