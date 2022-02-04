import 'package:flowers_app/domain/auth/app_user.dart';
import 'package:flowers_app/domain/notice/notice.dart';
import 'package:flowers_app/domain/notice/notice_list.dart';
import 'package:flowers_app/domain/order/order.dart';
import 'package:flowers_app/domain/order/order_list.dart';
import 'package:flowers_app/infrastructure/api/api_params.dart';
import 'package:flowers_app/infrastructure/api/api_request.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';
import 'package:flowers_app/infrastructure/datasource/data_source.dart';
import 'package:flowers_app/presentation/user_account/widgets/order_overview_body.dart';
import 'package:flowers_app/presentation/user_account/widgets/user_account_popup_menu_btn.dart';
import 'package:flutter/material.dart';

class UserAccountPage extends StatelessWidget {
  final DataSource dataSource;
  final AppUser user;
  const UserAccountPage({
    Key? key,
    required this.dataSource,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text(AppText.userAccount),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${user["name"]}'),
                    Text('Баланс: ${user["account"]}'),
                  ],
                ),
            ),
          ),
          const SizedBox(width: 2,),
          const UserAccountPopupMenuBtn(),
          const SizedBox(width: 8,),
        ],
      ),
      body: OrderOverviewBody(
        user: user,
        orderList: OrderList(
          remote: DataSet<Map<String, dynamic>>(
            params: ApiParams({
              'tableName': 'orderView',
              'where': [
                {'operator': 'where', 'field': 'client/id', 'cond': '=', 'value': '${user['id']}'},
                {'operator': 'and', 'field': 'deleted', 'cond': 'is null', 'value': null},
              ],
            }),
            apiRequest: const ApiRequest(
              url: 'http://u1489690.isp.regruhosting.ru/get-view',
            ),
          ),
          dataMaper: (row) => Order(
            id: '${row['id']}',
            remote: dataSource.dataSet('order_list'),
          ).fromRow(row),
        ),
        noticeList: NoticeList(
          remote: dataSource.dataSet('notice_list').withParams(params: {
            'client_id': '${user['id']}',
          },) as DataSet<Map<String, dynamic>>,
          dataMaper: (row) => Notice(
            id: '${row['id']}',
            remote: dataSource.dataSet('notice_list'),
          ).fromRow(row),
        ),
      ),
    );
  }
}
