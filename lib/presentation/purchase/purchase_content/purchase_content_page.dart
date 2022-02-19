import 'package:flowers_app/domain/auth/app_user.dart';
import 'package:flowers_app/domain/notice/notice_list_viewed.dart';
import 'package:flowers_app/domain/purchase/purchase.dart';
import 'package:flowers_app/domain/purchase/purchase_content.dart';
import 'package:flowers_app/domain/purchase/purchase_product.dart';
import 'package:flowers_app/infrastructure/api/api_params.dart';
import 'package:flowers_app/infrastructure/api/api_request.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';
import 'package:flowers_app/infrastructure/datasource/data_source.dart';
import 'package:flowers_app/presentation/purchase/purchase_content/widgets/purchase_content_body.dart';
import 'package:flutter/material.dart';

class PurchaseContentPage extends StatelessWidget {
  final AppUser user;
  final Purchase purchase;
  final DataSource dataSource;
  final NoticeListViewed _noticeListViewed;
  const PurchaseContentPage({
    Key? key,
    required this.user,
    required this.purchase,
    required this.dataSource,
    required NoticeListViewed noticeListViewed,
  }) : 
    _noticeListViewed = noticeListViewed,
    super(key: key);
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
          purchase['name'].toString(),
        ),
        actions: const <Widget>[
          // UncompletedSwitch(),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: PurchaseContentBody(
          purchaseContent: PurchaseContent(
            // id: purchase.id,
            remote: DataSet(
              params: ApiParams({
                'tableName': 'purchase_content_preview',
                'where': [{'operator': 'where', 'field': 'purchase/id', 'cond': '=', 'value': purchase.id}]
              }),
              apiRequest: const ApiRequest(
                url: 'http://u1489690.isp.regruhosting.ru/get-view',
              ),
            ),
            dataMaper: (row) => PurchaseProduct(
              userId: '${user['id']}',
              purchaseContentId: '${row['id']}', // purchase_content_id
              remote: dataSource.dataSet('purchase_product'),
            ).fromRow(row),
          ), 
          noticeListViewed: _noticeListViewed, 
        ),
      ),
    );
  }
}
