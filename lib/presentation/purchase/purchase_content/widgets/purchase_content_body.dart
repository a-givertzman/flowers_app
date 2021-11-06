import 'dart:async';

import 'package:flowers_app/domain/core/errors/failure.dart';
import 'package:flowers_app/domain/purchase/purchase.dart';
import 'package:flowers_app/domain/purchase/purchase_content.dart';
import 'package:flowers_app/domain/purchase/purchase_list.dart';
import 'package:flowers_app/domain/user/user.dart';
import 'package:flowers_app/presentation/core/widgets/critical_error_widget.dart';
import 'package:flowers_app/presentation/core/widgets/savingIn_pogress_overlay.dart';
import 'package:flowers_app/presentation/purchase/purchase_content/widgets/purchase_content_card.dart';
import 'package:flowers_app/presentation/purchase/purchase_overview/widgets/error_purchase_card.dart';
import 'package:flowers_app/presentation/purchase/purchase_overview/widgets/purchase_card.dart';
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
    final List<dynamic> purchases = snapshot.data ?? List.empty();
    print('[PurchaseContentBody._buildListView]');
    if (snapshot.hasData) {
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: purchases.length,
          itemBuilder: (context, index) {
            final purchase = purchases[index];
            if (purchase.valid()) {
              return PurchaseContentCard(purchaseProduct: purchase);
            } else {
              return const ErrorPurchaseCard(message: 'Ошибка чтения списка закупок');
            }
          },
        );
    } else if (snapshot.hasError) {
      return CriticalErrorWidget(
        message: snapshot.error.toString(),
        refresh: purchaseContent.refresh,
      );
    }
    return const SavingInProgressOverlay(isSaving: true);
  }
}
