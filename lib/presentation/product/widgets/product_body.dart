import 'package:flowers_app/domain/notice/notice_list.dart';
import 'package:flowers_app/domain/notice/notice_list_viewed.dart';
import 'package:flowers_app/domain/purchase/purchase_item.dart';
import 'package:flowers_app/presentation/product/widgets/product_card.dart';
import 'package:flowers_app/presentation/product/widgets/product_card_with_notices.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
///
/// Displays a detailed info about the PurchaseItem
class ProductBody extends StatelessWidget {
  static const _log = Log('ProductBody');
  final String customerId;
  final PurchaseItem purchaseItem;
  final NoticeList? _noticeList;
  final NoticeListViewed _noticeListViewed;
  ///
  ///
  const ProductBody({
    super.key,
    required this.customerId,
    required this.purchaseItem,
    NoticeList? noticeList,
    required NoticeListViewed noticeListViewed,
  }) : 
    _noticeList = noticeList,
    _noticeListViewed = noticeListViewed;
  //
  //
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final notices = _noticeList;
        if (notices != null) {
          _log.debug('.build | using ProductCardNotified');
          return ProductCardWithNotices(
            customerId: customerId,
            purchaseItem: purchaseItem,
            noticeList: notices, 
            noticeListViewed: _noticeListViewed,
            hasNotRead: notices.hasNew(
              fieldName: 'purchase_content_id', 
              value: purchaseItem.id,
            ), 
          );
        } else {
          _log.debug('.build | using ProductCard');
          return ProductCard(
            customerId: customerId,
            purchaseItem: purchaseItem,
          );
        }
      },
    );
  }
}
