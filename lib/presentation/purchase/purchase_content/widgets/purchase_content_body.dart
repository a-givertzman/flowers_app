import 'package:flowers_app/domain/purchase/purchase_content.dart';
import 'package:flowers_app/presentation/core/widgets/critical_error_widget.dart';
import 'package:flowers_app/presentation/core/widgets/savingIn_pogress_overlay.dart';
import 'package:flowers_app/presentation/purchase/purchase_content/widgets/purchase_content_card.dart';
import 'package:flowers_app/presentation/purchase/purchase_overview/widgets/error_purchase_card.dart';
import 'package:flutter/material.dart';

class PurchaseContentBody extends StatelessWidget {
  final PurchaseContent purchaseContent;
  const PurchaseContentBody({
    Key? key,
    required this.purchaseContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<dynamic>>(
      stream: purchaseContent.dataStream,
      builder: (context, snapshot) {
        return RefreshIndicator(
          displacement: 20.0,
          onRefresh: purchaseContent.refresh,
          child: _buildListViewWidget(context, snapshot)
        );
      }
    );
  }

  Widget _buildListViewWidget(
    BuildContext context, 
    AsyncSnapshot<List<dynamic>> snapshot
  ) {
    final List<dynamic> purchaseProducts = snapshot.data ?? List.empty();
    print('[PurchaseContentBody._buildListView]');
    if (snapshot.hasData) {
        return Scrollbar(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: purchaseProducts.length,
            itemBuilder: (context, index) {
              final purchaseProduct = purchaseProducts[index];
              if (purchaseProduct?.valid()) {
                return PurchaseContentCard(purchaseProduct: purchaseProduct);
              } else {
                return const ErrorPurchaseCard(message: 'Ошибка чтения товаров заккупки');
              }
            },
          ),
        );
    } else if (snapshot.hasError) {
      return CriticalErrorWidget(
        message: snapshot.error.toString(),
        refresh: purchaseContent.refresh,
      );
    }
    return const InProgressOverlay(isSaving: true);
  }
}
