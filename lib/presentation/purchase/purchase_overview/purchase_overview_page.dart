import 'package:flowers_app/domain/auth/app_user.dart';
import 'package:flowers_app/domain/purchase/purchase.dart';
import 'package:flowers_app/domain/purchase/purchase_list.dart';
import 'package:flowers_app/infrastructure/api/api_params.dart';
import 'package:flowers_app/infrastructure/api/api_request.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';
import 'package:flowers_app/infrastructure/datasource/data_source.dart';
import 'package:flowers_app/presentation/purchase/purchase_overview/widgets/purchase_overview_body.dart';
import 'package:flowers_app/presentation/user_account/user_account_page.dart';
import 'package:flutter/material.dart';

class PurchaseOverviewPage extends StatelessWidget {
  final DataSource dataSource;
  final AppUser user;
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
        automaticallyImplyLeading: false,
        // leading: IconButton(
        //   icon: const Icon(Icons.logout),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
        actions: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.account_circle),
                        tooltip: 'Личный кабинет',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  UserAccountPage(
                                dataSource: dataSource,
                                user: user,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
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
      body: Center(
        child: PurchaseOverviewBody(
          user: user,
          purchaseList: PurchaseList(
            remote: dataSource.dataSet('purchase'), 
            dataMaper: (row) => Purchase(
              id: '${row['id']}',
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
