import 'package:flowers_app/assets/texts/app_text.dart';
import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/auth/app_user.dart';
import 'package:flowers_app/domain/notice/notice_list_viewed.dart';
import 'package:flowers_app/domain/purchase/purchase.dart';
import 'package:flowers_app/domain/purchase/purchase_list.dart';
import 'package:flowers_app/domain/purchase/purchase_list_filtered.dart';
import 'package:flowers_app/infrastructure/api/api_params.dart';
import 'package:flowers_app/infrastructure/api/api_request.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';
import 'package:flowers_app/infrastructure/datasource/data_source.dart';
import 'package:flowers_app/presentation/core/widgets/icons.dart';
import 'package:flowers_app/presentation/purchase/purchase_overview/widgets/popup_menu_btn.dart';
import 'package:flowers_app/presentation/purchase/purchase_overview/widgets/purchase_overview_body.dart';
import 'package:flowers_app/presentation/user_account/user_account_page.dart';
import 'package:flutter/material.dart';

enum ViewFilter {all, actual, archived}

class PurchaseOverviewPage extends StatefulWidget {
  final DataSource dataSource;
  final AppUser user;
  final NoticeListViewed _noticeListViewed;
  PurchaseOverviewPage({
    Key? key,
    required this.dataSource,
    required this.user,
  }) : 
    _noticeListViewed = NoticeListViewed(clientId: '${user['id']}'),
    super(key: key);
  @override
  State<PurchaseOverviewPage> createState() => _PurchaseOverviewPageState();
}

class _PurchaseOverviewPageState extends State<PurchaseOverviewPage> {
  static const _debug = true;
  late NoticeListViewed _noticeListViewed;
  late List<String> _statusList;
  late ViewFilter _viewFilter;
  @override
  void initState() {
    super.initState();
    _viewFilter = ViewFilter.actual;
    _statusList = _viewStatusList(ViewFilter.actual);
    _noticeListViewed = widget._noticeListViewed;
  }
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
            ViewFilterPopupMenuBtn(
              initialValue: _viewFilter,
              color: _viewFilter == ViewFilter.actual
                ? Colors.black
                : Colors.primaries[9],
              onSelected: (viewFilterValue) {
                setState(() {
                  _viewFilter = viewFilterValue;
                  _statusList = _viewStatusList(viewFilterValue);
                });
                log(_debug, '[_PurchaseOverviewPageState.build] _filtered: ', _viewFilter);
                log(_debug, '[_PurchaseOverviewPageState.build] status List: ', _statusList);
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
                          noticeListViewed: _noticeListViewed,
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
            statusList: _statusList,
            purchaseList: PurchaseListFiltered(
              statusList: _statusList,
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
            noticeListViewed: _noticeListViewed, 
          ),
        ),
      ),
    );
  }
  List<String> _viewStatusList(ViewFilter viewFilter) {
    switch (viewFilter) {
      case ViewFilter.all:
        return ['prepare', 'active', 'purchase', 'distribute', 'archived', 'canceled'];
      case ViewFilter.actual:
        return ['active'];
      case ViewFilter.archived:
        return ['archived'];
      default:
        return ['active'];
    }
  }
}
