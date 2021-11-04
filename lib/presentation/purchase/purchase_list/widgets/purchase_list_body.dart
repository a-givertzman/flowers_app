import 'package:flowers_app/domain/purchase/purchase.dart';
import 'package:flowers_app/domain/purchase/purchase_list.dart';
import 'package:flowers_app/presentation/purchase/purchase_list/widgets/error_purchase_card.dart';
import 'package:flowers_app/presentation/purchase/purchase_list/widgets/purchase_card.dart';
import 'package:flutter/material.dart';

class PurchaseListBody extends StatelessWidget {
  final PurchaseList purchaseList;
  // final ScrollController _controller = ScrollController();

  const PurchaseListBody({
    Key? key,
    required this.purchaseList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: purchaseList.getList(
        purchaseList.dataSource.dataSet('purchase'),
      ),
      builder: (context, AsyncSnapshot<List<Purchase>> snapshot) {
        print('[PurchaseListBody.builder] snapshot:');
        print(snapshot);
        return _buildListView(snapshot);
      }
    );
  }
}

Widget _buildListView(AsyncSnapshot<List<Purchase>> snepshot) {
  List<Purchase> purchases = [];
  // = await purchaseList.getList(
  //   purchaseList.dataSource.dataSet('purchase'),
  // );
  print('[PurchaseListBody._buildListView]');
  if (snepshot.hasData) {
    final data = snepshot.data;
    if (data != null) {
      purchases = data;
    }
  }
  print('[PurchaseListBody._buildListView] purchases:');
  print(purchases);
  return ListView.builder(
    physics: const BouncingScrollPhysics(),
    itemCount: purchases.length,
    itemBuilder: (context, index) {
      final purchase = purchases[index];
      print('[PurchaseListBody.ListView.builder]');
      if (purchase.valid()) {
        return PurchaseCard(purchase: purchase);
      } else {
        return const ErrorPurchaseCard(message: 'Ошибка чтения списка закупок');
      }
    },
  );
}
