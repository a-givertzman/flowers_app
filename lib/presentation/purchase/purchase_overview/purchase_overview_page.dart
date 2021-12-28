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
          Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PopupMenuButton(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/filtered.png',
                      width: 36.0,
                      height: 36.0,
                      color: Colors.primaries[9],
                    ),
                    // const Text('Фильтр',
                    //   style: TextStyle(
                    //     height: 1.3,
                    //     fontSize: 10.5,
                    //   ),
                    // ),
                  ],
                ),
                onSelected: (value) {
                  
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/icons/select-all.png',
                            width: 32.0,
                            height: 32.0,
                            color: Colors.primaries[9],
                          ),
                          const Text('Все'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/icons/ic_access_time.png',
                            width: 32.0,
                            height: 32.0,
                            color: Colors.primaries[9],
                          ),
                          const Text('Актуальные'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/icons/ic_history.png',
                            width: 32.0,
                            height: 32.0,
                            color: Colors.primaries[9],
                          ),
                          const Text('Архивные'),
                        ],
                      ),
                    ),
                  ];
                },
              ),              
              const SizedBox(width: 4.0),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.account_circle,
                      size: 42,
                    ),
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
              const SizedBox(width: 16.0),
            ],
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
