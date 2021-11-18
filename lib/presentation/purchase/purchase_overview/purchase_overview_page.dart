import 'package:flowers_app/domain/purchase/purchase.dart';
import 'package:flowers_app/domain/purchase/purchase_list.dart';
import 'package:flowers_app/domain/auth/user.dart';
import 'package:flowers_app/infrastructure/api/api_params.dart';
import 'package:flowers_app/infrastructure/api/api_request.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';
import 'package:flowers_app/infrastructure/datasource/data_source.dart';
import 'package:flowers_app/presentation/purchase/purchase_overview/widgets/purchase_overview_body.dart';
import 'package:flutter/material.dart';

class PurchaseOverviewPage extends StatelessWidget {
  final DataSource dataSource;
  final User user;
  const PurchaseOverviewPage({
    Key? key,
    required this.dataSource,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              title: const Text('Закупки'),
              leading: IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: <Widget>[
                    Center(
                      child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${user["name"]}'),
                    Text('Баланс: ${user["account"]}'),
                  ],
                ),
              ),
                    ),
                // UncompletedSwitch(),
              ],
              automaticallyImplyLeading: false,
            ),
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () {
            //     //TODO FloatingActionButton action to be implemented
            //     throw Exception('FloatingActionButton action to be implemented');
            //     // AutoRouter.of(context).push(NoteFormPageRoute(note: null));
            //   },
            //   child: const Icon(Icons.add),
            // ),
            body: Center(
                  child: PurchaseOverviewBody(
                    user: user,
                    purchaseList: PurchaseList(
                      id: '${user['id']}',
                      remote: dataSource.dataSet('purchase'), 
                      dataMaper: (row) => Purchase(
                        id: row['id'],
                        remote: DataSet(
                          params: ApiParams(const {
                            'tableName': 'purchase_content_preview',
                          }),
                          apiRequest: const ApiRequest(
                            url: 'http://u1489690.isp.regruhosting.ru/get-view',
                          ),
                        ),
                      ).fromRow(row),
                    ), 
                  ),
                ),
    );
  }
}
