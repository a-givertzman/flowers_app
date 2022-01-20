import 'package:flowers_app/assets/texts/app_text.dart';
import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/auth/app_user.dart';
import 'package:flowers_app/domain/purchase/purchase.dart';
import 'package:flowers_app/domain/purchase/purchase_list.dart';
import 'package:flowers_app/infrastructure/api/api_params.dart';
import 'package:flowers_app/infrastructure/api/api_request.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';
import 'package:flowers_app/infrastructure/datasource/data_source.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flowers_app/presentation/core/widgets/icons.dart';
import 'package:flowers_app/presentation/purchase/purchase_overview/widgets/popup_menu_btn.dart';
import 'package:flowers_app/presentation/purchase/purchase_overview/widgets/purchase_overview_body.dart';
import 'package:flowers_app/presentation/user_account/user_account_page.dart';
import 'package:flutter/material.dart';

enum viewFilter {all, actual, archived}

class PurchaseOverviewPage extends StatefulWidget {
  final DataSource dataSource;
  final AppUser user;
  const PurchaseOverviewPage({
    Key? key,
    required this.dataSource,
    required this.user,
  }) : super(key: key);

  @override
  State<PurchaseOverviewPage> createState() => _PurchaseOverviewPageState();
}

class _PurchaseOverviewPageState extends State<PurchaseOverviewPage> {
  var _filtered = viewFilter.actual;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(AppText.purchases),
          automaticallyImplyLeading: false,
          // leading: IconButton(
          //   icon: const Icon(Icons.logout),
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //   },
          // ),
          actions: <Widget>[
            UserAccountPopupMenuBtn(
              initialValue: _filtered,
              color: _filtered == viewFilter.actual
                ? Colors.black
                : Colors.primaries[9],
              onSelected: (value) {
                setState(() {
                  _filtered = value;
                });
              },
            ),
            const SizedBox(width: 4.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: appIcons.accountCircle,
                  tooltip: AppText.userAccount,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>  UserAccountPage(
                          dataSource: widget.dataSource,
                          user: widget.user,
                        ),
                        settings: const RouteSettings(name: "/userAccountPage"),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(width: 16.0),
          ],
        ),
        body: Center(
          child: PurchaseOverviewBody(
            user: widget.user,
            purchaseList: PurchaseList(
              remote: widget.dataSource.dataSet('purchase'), 
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
      ),
    );
  }
}
