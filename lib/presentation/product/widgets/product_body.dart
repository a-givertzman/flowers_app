import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/notice/notice_list.dart';
import 'package:flowers_app/domain/notice/notice_list_viewed.dart';
import 'package:flowers_app/domain/purchase/purchase_product.dart';
import 'package:flowers_app/presentation/product/widgets/product_card.dart';
import 'package:flowers_app/presentation/product/widgets/product_card_with_notices.dart';
import 'package:flutter/material.dart';

class ProductBody extends StatelessWidget {
  static const _debug = false;
  final PurchaseProduct purchaseProduct;
  final NoticeList? _noticeList;
  final NoticeListViewed _noticeListViewed;
  const ProductBody({
    Key? key,
    required this.purchaseProduct,
    NoticeList? noticeList,
    required NoticeListViewed noticeListViewed,
  }) : 
    _noticeList = noticeList,
    _noticeListViewed = noticeListViewed,
    super(key: key);
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final _notices = _noticeList;
        if (_notices != null) {
          log(_debug, '[ProductBody.build] using ProductCardNotified');
          return ProductCardWithNotices(
            purchaseProduct: purchaseProduct,
            noticeList: _notices, 
            noticeListViewed: _noticeListViewed,
            hasNotRead: _notices.hasNotRead(
              fieldName: 'purchase_content/id', 
              value: '${purchaseProduct['purchase_content/id']}',
            ), 
          );
        } else {
          log(_debug, '[ProductBody.build] using ProductCard');
          return ProductCard(
            purchaseProduct: purchaseProduct,
          );
        }
      },
    );
  }
}
