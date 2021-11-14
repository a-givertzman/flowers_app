import 'package:flowers_app/domain/purchase/purchase_list.dart';
import 'package:flowers_app/domain/user/user.dart';
import 'package:flowers_app/presentation/core/widgets/critical_error_widget.dart';
import 'package:flowers_app/presentation/core/widgets/savingIn_pogress_overlay.dart';
import 'package:flowers_app/presentation/purchase/purchase_overview/widgets/error_purchase_card.dart';
import 'package:flowers_app/presentation/purchase/purchase_overview/widgets/purchase_card.dart';
import 'package:flutter/material.dart';

class PurchaseOverviewBody extends StatelessWidget {
  final User user;
  final PurchaseList purchaseList;
  const PurchaseOverviewBody({
    Key? key,
    required this.user,
    required this.purchaseList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<dynamic>>(
      stream: purchaseList.dataStream,
      builder: (context, snapshot) {
        return RefreshIndicator(
          onRefresh: purchaseList.refresh,
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
    print('[PurchaseOverviewBody._buildListView]');
    if (snapshot.hasError) {
      print('[PurchaseOverviewBody._buildListView] snapshot hasError');
      return CriticalErrorWidget(
        message: snapshot.error.toString(),
        refresh: purchaseList.refresh,
      );
    } else if (snapshot.hasData) {
      print('[PurchaseOverviewBody._buildListView] snapshot hasData');
      print('[PurchaseOverviewBody._buildListView] data');
      print(snapshot.data);
      return Scrollbar(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: purchases.length,
          itemBuilder: (context, index) {
            final purchase = purchases[index];
            if (purchase.valid()) {
              return PurchaseCard(
                user: user,
                purchase: purchase,
              );
            } else {
              return const ErrorPurchaseCard(message: 'Ошибка чтения списка закупок');
            }
          },
        ),
      );
    } else {
      print('[PurchaseOverviewBody._buildListView] is loading');
      return const InProgressOverlay(isSaving: true);
    }
  }
}
