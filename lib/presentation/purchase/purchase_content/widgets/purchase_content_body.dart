import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/auth/app_user.dart';
import 'package:flowers_app/domain/notice/notice_list_viewed.dart';
import 'package:flowers_app/domain/purchase/purchase_content.dart';
import 'package:flowers_app/domain/purchase/purchase_product.dart';
import 'package:flowers_app/presentation/core/widgets/critical_error_widget.dart';
import 'package:flowers_app/presentation/core/widgets/in_pogress_overlay.dart';
import 'package:flowers_app/presentation/purchase/purchase_content/widgets/purchase_content_card.dart';
import 'package:flowers_app/presentation/purchase/purchase_overview/widgets/error_purchase_card.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
///
///
class PurchaseContentBody extends StatelessWidget {
  static const _debug = false;
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
    return FutureBuilder<Result<Map<String, PurchaseProduct>, Failure<dynamic>>>(
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
    AsyncSnapshot<Result<Map<String, PurchaseProduct>, Failure<dynamic>>> snapshot,
  ) {
    log(_debug, '[PurchaseContentBody._buildListView]');
    if (snapshot.hasData) {
      switch (snapshot.data) {
        case null:
          return const InProgressOverlay(
            isSaving: true,
            message: 'Загружаю...',
          );
        case Ok<Map<String, PurchaseProduct>, Failure>(value: final map):
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
                    purchaseProduct: product,
                    noticeListViewed: _noticeListViewed,
                  );
                } else {
                  return const ErrorPurchaseCard(message: 'Ошибка чтения товаров заккупки');
                }
              },
            ),
          );
        case Err<Map<String, PurchaseProduct>, Failure>():
          return CriticalErrorWidget(
            message: snapshot.error.toString(),
            refresh: purchaseContent.refresh,
          );
      }
    } else if (snapshot.hasError) {
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
