import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/notice/notice_list.dart';
import 'package:flowers_app/domain/notice/notice_list_viewed.dart';
import 'package:flowers_app/domain/purchase/purchase_product.dart';
import 'package:flowers_app/presentation/product/widgets/product_card.dart';
import 'package:flowers_app/presentation/product/widgets/product_card_with_notices.dart';
import 'package:flutter/material.dart';
///
///
class ProductBody extends StatelessWidget {
  static const _debug = false;
  final String customerId;
  final PurchaseProduct purchaseProduct;
  final NoticeList? _noticeList;
  final NoticeListViewed _noticeListViewed;
  ///
  ///
  const ProductBody({
    super.key,
    required this.customerId,
    required this.purchaseProduct,
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
          log(_debug, 'ProductBody.build | using ProductCardNotified');
          return ProductCardWithNotices(
            customerId: customerId,
            purchaseProduct: purchaseProduct,
            noticeList: notices, 
            noticeListViewed: _noticeListViewed,
            hasNotRead: notices.hasNew(
              fieldName: 'purchase_content_id', 
              value: purchaseProduct.id,
            ), 
          );
        } else {
          log(_debug, 'ProductBody.build | using ProductCard');
          return ProductCard(
            customerId: customerId,
            purchaseProduct: purchaseProduct,
          );
        }
      },
    );
  }
}
