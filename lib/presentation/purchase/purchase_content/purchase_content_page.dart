import 'package:flowers_app/domain/auth/app_user.dart';
import 'package:flowers_app/domain/notice/notice_list_viewed.dart';
import 'package:flowers_app/domain/purchase/purchase.dart';
import 'package:flowers_app/domain/purchase/purchase_content.dart';
import 'package:flowers_app/presentation/purchase/purchase_content/widgets/purchase_content_body.dart';
import 'package:flutter/material.dart';

class PurchaseContentPage extends StatelessWidget {
  final AppUser user;
  final Purchase purchase;
  final NoticeListViewed _noticeListViewed;
  const PurchaseContentPage({
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
        child: PurchaseContentBody(
          purchaseContent: PurchaseContent(), 
          noticeListViewed: _noticeListViewed, 
        ),
      ),
    );
  }
}
