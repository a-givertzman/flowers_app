import 'package:flower_app/domain/auth/app_user.dart';
import 'package:flower_app/domain/notice/notice_list.dart';
import 'package:flower_app/domain/notice/notice_list_viewed.dart';
import 'package:flower_app/domain/purchase/purchase_item.dart';
import 'package:flower_app/presentation/product/widgets/product_body.dart';
import 'package:flutter/material.dart';
///
/// Displays a detailed info about the PurchaseItem
class ProductPage extends StatelessWidget {
  final AppUser _customer;
  final PurchaseItem purchaseItem;
  final NoticeList? _noticeList;
  final NoticeListViewed _noticeListViewed;
  ///
  ///
  const ProductPage({
    super.key,
    required AppUser user,
    required this.purchaseItem,
    NoticeList? noticeList,
    required NoticeListViewed noticeListViewed,
  }) : 
    _customer = user,
    _noticeList = noticeList,
    _noticeListViewed = noticeListViewed;
  //
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          purchaseItem.product_name,
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
        customerId: _customer.id,
        purchaseItem: purchaseItem,
        noticeList: _noticeList,
        noticeListViewed: _noticeListViewed,
      ),
    );
  }
}
