import 'package:flowers_app/assets/texts/app_text.dart';
import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/auth/app_user.dart';
import 'package:flowers_app/domain/notice/notice_list_viewed.dart';
import 'package:flowers_app/domain/purchase/purchase.dart';
import 'package:flowers_app/domain/purchase/purchase_list.dart';
import 'package:flowers_app/presentation/core/widgets/critical_error_widget.dart';
import 'package:flowers_app/presentation/core/widgets/in_pogress_overlay.dart';
import 'package:flowers_app/presentation/purchase/purchase_overview/widgets/error_purchase_card.dart';
import 'package:flowers_app/presentation/purchase/purchase_overview/widgets/purchase_card.dart';
import 'package:flutter/material.dart';

class PurchaseOverviewBody extends StatelessWidget {
  final AppUser user;
  final PurchaseList purchaseList;
  final NoticeListViewed _noticeListViewed;
  const PurchaseOverviewBody({
    Key? key,
    required this.user,
    required this.purchaseList,
    required NoticeListViewed noticeListViewed,
  }) : 
    _noticeListViewed = noticeListViewed,
    super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Purchase>>(
      stream: purchaseList.dataStream,
      builder: (context, snapshot) {
        return RefreshIndicator(
          displacement: 20.0,
          onRefresh: purchaseList.refresh,
          child: _buildListViewWidget(context, snapshot),
        );
      },
    );
  }

  Widget _buildListViewWidget(
    BuildContext context, 
    AsyncSnapshot<List<Purchase>> snapshot,
  ) {
    final List<dynamic> purchases = snapshot.data ?? List.empty();
    log('[PurchaseOverviewBody._buildListView]');
    if (snapshot.hasError) {
      log('[PurchaseOverviewBody._buildListView] snapshot hasError');
      return CriticalErrorWidget(
        message: snapshot.error.toString(),
        refresh: purchaseList.refresh,
      );
    } else if (snapshot.hasData) {
      log('[PurchaseOverviewBody._buildListView] snapshot hasData');
      log('[PurchaseOverviewBody._buildListView] data: ', snapshot.data);
      return Scrollbar(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: purchases.length,
          itemBuilder: (context, index) {
            final purchase = purchases[index] as Purchase;
            if (purchase.valid()) {
              return PurchaseCard(
                user: user,
                purchase: purchase, 
                noticeListViewed: _noticeListViewed,
              );
            } else {
              return const ErrorPurchaseCard(message: 'Ошибка чтения списка закупок');
            }
          },
        ),
      );
    } else {
      log('[PurchaseOverviewBody._buildListView] is loading');
      return const InProgressOverlay(
        isSaving: true,
        message: AppText.loading,
      );
    }
  }
}
