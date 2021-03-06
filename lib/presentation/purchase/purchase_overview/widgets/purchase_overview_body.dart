import 'package:flowers_app/assets/texts/app_text.dart';
import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/auth/app_user.dart';
import 'package:flowers_app/domain/notice/notice_list_viewed.dart';
import 'package:flowers_app/domain/purchase/purchase.dart';
import 'package:flowers_app/domain/purchase/purchase_list_filtered.dart';
import 'package:flowers_app/presentation/core/widgets/critical_error_widget.dart';
import 'package:flowers_app/presentation/core/widgets/in_pogress_overlay.dart';
import 'package:flowers_app/presentation/purchase/purchase_overview/widgets/error_purchase_card.dart';
import 'package:flowers_app/presentation/purchase/purchase_overview/widgets/purchase_card.dart';
import 'package:flutter/material.dart';

class PurchaseOverviewBody extends StatelessWidget {
  static const _debug = true;
  final AppUser user;
  final PurchaseListFiltered purchaseList;
  final NoticeListViewed _noticeListViewed;
  final List<String> _statusList;
  const PurchaseOverviewBody({
    Key? key,
    required this.user,
    required this.purchaseList,
    required NoticeListViewed noticeListViewed,
    required List<String> statusList,
  }) : 
    _statusList = statusList,
    _noticeListViewed = noticeListViewed,
    super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Purchase>>(
      stream: purchaseList.dataStream,
      builder: (context, snapshot) {
        return RefreshIndicator(
          displacement: 20.0,
          onRefresh: () {
            return purchaseList.refresh(_statusList);
          },
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
    log(_debug, '[PurchaseOverviewBody._buildListView]');
    if (snapshot.hasError) {
      log(_debug, '[PurchaseOverviewBody._buildListView] snapshot hasError');
      return CriticalErrorWidget(
        message: snapshot.error.toString(),
        refresh: () {
          return purchaseList.refresh(_statusList);
        },
      );
    } else if (snapshot.hasData) {
      log(_debug, '[PurchaseOverviewBody._buildListView] snapshot hasData');
      log(_debug, '[PurchaseOverviewBody._buildListView] data: ', snapshot.data);
      return Scrollbar(
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
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
              return const ErrorPurchaseCard(message: '???????????? ???????????? ???????????? ??????????????');
            }
          },
        ),
      );
    } else {
      log(_debug, '[PurchaseOverviewBody._buildListView] is loading');
      return const InProgressOverlay(
        isSaving: true,
        message: AppText.loading,
      );
    }
  }
}
