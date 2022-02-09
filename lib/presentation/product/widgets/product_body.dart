import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/notice/notice_list.dart';
import 'package:flowers_app/domain/purchase/purchase_product.dart';
import 'package:flowers_app/presentation/product/widgets/product_card.dart';
import 'package:flowers_app/presentation/product/widgets/product_card_with_notices.dart';
import 'package:flutter/material.dart';

class ProductBody extends StatelessWidget {
  final PurchaseProduct purchaseProduct;
  final NoticeList? _noticeList;
  const ProductBody({
    Key? key,
    required this.purchaseProduct,
    NoticeList? noticeList,
  }) : 
    _noticeList = noticeList,
    super(key: key);
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final _notices = _noticeList;
        if (_notices != null) {
          log('[ProductBody.build] using ProductCardNotified');
          return ProductCardWithNotices(
            purchaseProduct: purchaseProduct,
            noticeList: _notices,
          );
        } else {
          log('[ProductBody.build] using ProductCard');
          return ProductCard(
            purchaseProduct: purchaseProduct,
          );
        }
      },
    );
  }
}
