import 'package:flowers_app/domain/notice/notice_list.dart';
import 'package:flowers_app/domain/notice/notice_list_viewed.dart';
import 'package:flowers_app/domain/purchase/purchase_product.dart';
import 'package:flowers_app/presentation/product/widgets/product_body.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  final PurchaseProduct product;
  final NoticeList? _noticeList;
  final NoticeListViewed _noticeListViewed;
  const ProductPage({
    Key? key,
    required this.product,
    NoticeList? noticeList,
    required NoticeListViewed noticeListViewed,
  }) : 
    _noticeList = noticeList,
    _noticeListViewed = noticeListViewed,
    super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '${product['product/name']}',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: const <Widget>[
        ],
        automaticallyImplyLeading: false,
      ),
      body: ProductBody(
        purchaseProduct: product,
        noticeList: _noticeList,
        noticeListViewed: _noticeListViewed,
      ),
    );
  }
}
