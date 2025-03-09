import 'package:flower_app/domain/auth/app_user.dart';
import 'package:flower_app/domain/core/translate/translate.dart';
import 'package:flower_app/domain/notice/notice_list_viewed.dart';
import 'package:flower_app/domain/purchase/purchase_items.dart';
import 'package:flower_app/domain/purchase/purchase_item.dart';
import 'package:flower_app/presentation/core/widgets/critical_error_widget.dart';
import 'package:flower_app/presentation/core/widgets/in_pogress_overlay.dart';
import 'package:flower_app/presentation/purchase/purchase_item/widgets/purchase_item_card.dart';
import 'package:flower_app/presentation/purchase/purchase_overview/widgets/error_purchase_card.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';
///
/// The list of PurchaseItem's
class PurchaseItemBody extends StatelessWidget {
  static const _log = Log('PurchaseItemBody');
  final AppUser _user;
  final PurchaseItems purchaseContent;
  final NoticeListViewed _noticeListViewed;
  const PurchaseItemBody({
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
          final purchaseItems = map.values.toList();
          if (purchaseItems.isEmpty) {
            return Column(
              mainAxisSize: MainAxisSize.min, // это оцентрирует по верикали
              children: [
                Text(
                  'No products added yet'.inRu,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4,),
                TextButton(
                  onPressed: () {},
                  child: Text('Reload'.inRu)
                ),
              ],
            );
          }
          return Scrollbar(
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: purchaseItems.length,
              itemBuilder: (context, index) {
                final purchaseItem = purchaseItems[index];
                if (purchaseItem.valid) {
                  return PurchaseItemCard(
                    user: _user,
                    purchaseItem: purchaseItem,
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
