import 'package:flower_app/assets/texts/app_text.dart';
import 'package:flower_app/domain/auth/app_user.dart';
import 'package:flower_app/domain/notice/notice_list_viewed.dart';
import 'package:flower_app/domain/purchase/purchase.dart';
import 'package:flower_app/domain/purchase/purchase_list_filtered.dart';
import 'package:flower_app/presentation/core/widgets/critical_error_widget.dart';
import 'package:flower_app/presentation/core/widgets/in_pogress_overlay.dart';
import 'package:flower_app/presentation/purchase/purchase_overview/widgets/error_purchase_card.dart';
import 'package:flower_app/presentation/purchase/purchase_overview/widgets/purchase_card.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';
///
///
class PurchaseOverviewBody extends StatelessWidget {
  static const _log = Log('PurchaseOverviewBody');
  final AppUser user;
  final PurchaseListFiltered purchaseList;
  final NoticeListViewed _noticeListViewed;
  final List<String> _statusList;
  ///
  ///
  const PurchaseOverviewBody({
    super.key,
    required this.user,
    required this.purchaseList,
    required NoticeListViewed noticeListViewed,
    required List<String> statusList,
  }) : 
    _statusList = statusList,
    _noticeListViewed = noticeListViewed;
  //
  //
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Result<List<Purchase>, Failure>>(
      future: purchaseList.refresh(_statusList),
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
  ///
  ///
  Widget _buildListViewWidget(
    BuildContext context, 
    AsyncSnapshot<Result<List<Purchase>, Failure>> snapshot,
  ) {
    _log.debug('._buildListView');
    if (snapshot.hasError) {
      _log.warning('._buildListView | snapshot hasError');
      return CriticalErrorWidget(
        message: snapshot.error.toString(),
        refresh: () {
          return purchaseList.refresh(_statusList);
        },
      );
    } else if (snapshot.hasData) {
      switch (snapshot.data) {
        case null:
          return const InProgressOverlay(
            isSaving: true,
            message: AppText.loading,
          );
        case Ok<List<Purchase>, Failure>(value: final purchases):
          _log.debug('._buildListView | snapshot hasData');
          _log.debug('._buildListView | data: ', snapshot.data);
          return Scrollbar(
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: purchases.length,
              itemBuilder: (context, index) {
                final purchase = purchases[index];
                if (purchase.valid) {
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
        case Err<List<Purchase>, Failure>(:final error):
          return CriticalErrorWidget(
            message: error.message.toString(),
            refresh: () {
              return purchaseList.refresh(_statusList);
            },
          );
      }
    } else {
      _log.debug('._buildListView | is loading');
      return const InProgressOverlay(
        isSaving: true,
        message: AppText.loading,
      );
    }
  }
}
