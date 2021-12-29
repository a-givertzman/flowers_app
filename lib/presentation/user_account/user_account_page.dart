import 'package:flowers_app/domain/auth/app_user.dart';
import 'package:flowers_app/domain/order/order.dart';
import 'package:flowers_app/domain/order/order_list.dart';
import 'package:flowers_app/infrastructure/api/api_params.dart';
import 'package:flowers_app/infrastructure/api/api_request.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';
import 'package:flowers_app/infrastructure/datasource/data_source.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flowers_app/presentation/user_account/widgets/order_overview_body.dart';
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
            Navigator.pop(context);
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
          IconButton(
            icon: Icon(
              Icons.logout,
              size: 38,
              color: appThemeData.colorScheme.tertiaryContainer,
            ),
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          ),
          const SizedBox(width: 8,),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     //TODO FloatingActionButton action to be implemented
      //     throw Exception('FloatingActionButton action to be implemented');
      //     // AutoRouter.of(context).push(NoteFormPageRoute(note: null));
      //   },
      //   child: const Icon(Icons.add),
      // ),
      body: OrderOverviewBody(
        user: user,
        orderList: OrderList(
          remote: DataSet<Map<String, dynamic>>(
            params: ApiParams({
              'tableName': 'orderView',
              'where': [{'operator': 'where', 'field': 'client/id', 'cond': '=', 'value': '${user['id']}'}]
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
      ),
    );
  }
}
