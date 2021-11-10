import 'package:flowers_app/domain/purchase/purchase_product.dart';
import 'package:flowers_app/presentation/core/widgets/savingIn_pogress_overlay.dart';
import 'package:flowers_app/presentation/product/widgets/product_card.dart';
import 'package:flutter/material.dart';

class ProductBody extends StatelessWidget {
  final PurchaseProduct purchaseProduct;
  const ProductBody({
    Key? key,
    required this.purchaseProduct,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      // stream: product.dataStream,
      builder: (context) => _buildProductWidget(context, purchaseProduct),
      //(context, snapshot) { 
        // return RefreshIndicator(
        //   onRefresh: product.refresh,
        //   child: _buildListViewWidget(context, snapshot)
        // ).;
      // }
    );
  }

  Widget _buildProductWidget(
    BuildContext context, 
    PurchaseProduct product,
    // AsyncSnapshot<List<dynamic>> snapshot
  ) {
    // final List<dynamic> purchases = snapshot.data ?? List.empty();
    print('[ProductBody._buildListView]');
    // if (product != null) {
      return ProductCard(
        purchaseProduct: product,
        onSubmit: (count) =>  _sendOrder(count, product),
      );
    // if (snapshot.hasData) {
    //     return ListView.builder(
    //       physics: const BouncingScrollPhysics(),
    //       itemCount: purchases.length,
    //       itemBuilder: (context, index) {
    //         final purchase = purchases[index];
    //         if (purchase?.valid()) {
    //           return PurchaseContentCard(purchaseProduct: purchase);
    //         } else {
    //           return const ErrorPurchaseCard(message: 'Ошибка чтения списка закупок');
    //         }
    //       },
    //     );
    // } else if (snapshot.hasError) {
      // return CriticalErrorWidget(
        // message: snapshot.error.toString(),
        // refresh: purchaseContent.refresh,
      // );
  //   }
  //   return const InProgressOverlay(isSaving: true);
  }
  _sendOrder(int count, PurchaseProduct product) {
    product.sendOrder(count);
  }
}
