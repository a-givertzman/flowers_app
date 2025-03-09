import 'package:flower_app/domain/auth/app_user.dart';
import 'package:flower_app/domain/notice/notice_list_viewed.dart';
import 'package:flower_app/domain/purchase/purchase.dart';
import 'package:flower_app/domain/purchase/purchase_items.dart';
import 'package:flower_app/presentation/purchase/purchase_item/widgets/purchase_items_body.dart';
import 'package:flutter/material.dart';
///
///
class PurchaseItemsPage extends StatelessWidget {
  final AppUser user;
  final Purchase purchase;
  final NoticeListViewed _noticeListViewed;
  const PurchaseItemsPage({
    super.key,
    required this.user,
    required this.purchase,
    required NoticeListViewed noticeListViewed,
  }) : 
    _noticeListViewed = noticeListViewed;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: PurchaseListSetting.appBarTitleBgColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          purchase.name,
        ),
        actions: const <Widget>[
          // UncompletedSwitch(),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: PurchaseItemsBody(
          user: user,
          purchaseItems: PurchaseItems(purchaseId: purchase.id),
          noticeListViewed: _noticeListViewed, 
        ),
      ),
    );
  }
}
