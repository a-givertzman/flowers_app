import 'package:flowers_app/domain/auth/app_user.dart';
import 'package:flowers_app/domain/notice/notice_list.dart';
import 'package:flowers_app/domain/purchase/purchase_product.dart';
import 'package:flowers_app/infrastructure/datasource/data_source.dart';
import 'package:flowers_app/presentation/notice/widgets/notice_overview_body.dart';
import 'package:flutter/material.dart';

class NoticeOverviewPage extends StatelessWidget {
  final AppUser user;
  final PurchaseProduct product;
  final DataSource dataSource;
  final NoticeList _noticeList;
  const NoticeOverviewPage({
    Key? key,
    required this.user,
    required this.product,
    required this.dataSource,
    required NoticeList noticeList,
  }) : 
    _noticeList = noticeList,
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
      body: NoticeOverviewBody(
        // user: user,
        purchaseContentId: '${product['purchase_content/id']}',
        noticeList: _noticeList,
        enableUserMessage: false,
      ),
    );
  }
}
