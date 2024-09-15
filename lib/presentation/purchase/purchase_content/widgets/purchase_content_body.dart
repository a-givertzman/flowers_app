import 'package:flowers_app/domain/auth/app_user.dart';
import 'package:flowers_app/domain/notice/notice_list_viewed.dart';
import 'package:flowers_app/domain/purchase/purchase_content.dart';
import 'package:flowers_app/domain/purchase/purchase_item.dart';
import 'package:flowers_app/presentation/core/widgets/critical_error_widget.dart';
import 'package:flowers_app/presentation/core/widgets/in_pogress_overlay.dart';
import 'package:flowers_app/presentation/purchase/purchase_content/widgets/purchase_content_card.dart';
import 'package:flowers_app/presentation/purchase/purchase_overview/widgets/error_purchase_card.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
///
/// The list of PurchaseItem's
class PurchaseContentBody extends StatelessWidget {
  static const _log = Log('PurchaseContentBody');
  final AppUser _user;
  final PurchaseContent purchaseContent;
  final NoticeListViewed _noticeListViewed;
  const PurchaseContentBody({
    super.key,
    required AppUser user,
    required this.purchaseContent,
    required NoticeListViewed noticeListViewed,
  }) : 
    _user = user,
    _noticeListViewed = noticeListViewed;
  //
  //
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Result<Map<String, PurchaseItem>, Failure<dynamic>>>(
      future: purchaseContent.fetch(),
      builder: (context, snapshot) {
        return RefreshIndicator(
          displacement: 20.0,
          onRefresh: purchaseContent.refresh,
          child: _buildListViewWidget(context, snapshot),
        );
      },
    );
  }
  ///
  ///
  Widget _buildListViewWidget(
    BuildContext context, 
    AsyncSnapshot<Result<Map<String, PurchaseItem>, Failure<dynamic>>> snapshot,
  ) {
    _log.debug('._buildListViewWidget |');
    if (snapshot.hasData) {
      _log.debug('._buildListViewWidget | snapshot - hasData: ${snapshot.data}');
      switch (snapshot.data) {
        case null:
          _log.debug('._buildListViewWidget | Null received');
          return const InProgressOverlay(
            isSaving: true,
            message: 'Загружаю...',
          );
        case Ok<Map<String, PurchaseItem>, Failure>(value: final map):
          _log.debug('._buildListViewWidget | Data map received');
          final products = map.values.toList();
          return Scrollbar(
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                if (product.valid) {
                  return PurchaseContentCard(
                    user: _user,
                    purchaseItem: product,
                    noticeListViewed: _noticeListViewed,
                  );
                } else {
                  return const ErrorPurchaseCard(message: 'Ошибка чтения товаров заккупки');
                }
              },
            ),
          );
        case Err<Map<String, PurchaseItem>, Failure>(:final error):
          _log.warning('._buildListViewWidget | Error received: $error');
          return CriticalErrorWidget(
            message: snapshot.error.toString(),
            refresh: purchaseContent.refresh,
          );
      }
    } else if (snapshot.hasError) {
      _log.warning('._buildListViewWidget | snapshot - hasError: ${snapshot.error}');
      return CriticalErrorWidget(
        message: snapshot.error.toString(),
        refresh: purchaseContent.refresh,
      );
    }
    return const InProgressOverlay(
      isSaving: true,
      message: 'Загружаю...',
    );
  }
}
