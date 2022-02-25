import 'package:flowers_app/assets/texts/app_text.dart';
import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/auth/app_user.dart';
import 'package:flowers_app/domain/auth/user_group.dart';
import 'package:flowers_app/domain/notice/notice_list_viewed.dart';
import 'package:flowers_app/domain/purchase/purchase.dart';
import 'package:flowers_app/domain/purchase/purchase_list.dart';
import 'package:flowers_app/domain/purchase/purchase_list_filtered.dart';
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

enum ViewFilter {all, prepare, active, purchase, distribute, archived, canceled}

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
    _viewFilter = ViewFilter.active;
    _statusList = _viewStatusList(widget.user, ViewFilter.active);
    _noticeListViewed = widget._noticeListViewed;
  }
  @override
  Widget build(BuildContext context) {
    log(_debug, '[_PurchaseOverviewPageState.build] user: ', widget.user);
    final userGroup = UserGroup(group: '${widget.user['group']}');
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(AppText.purchases),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            ViewFilterPopupMenuBtn(
              userGroup: userGroup,
              initialValue: _viewFilter,
              color: _viewFilter == ViewFilter.active
                ? Colors.black
                : Colors.primaries[9],
              onSelected: (viewFilterValue) {
                setState(() {
                  _viewFilter = viewFilterValue;
                  _statusList = _viewStatusList(widget.user, viewFilterValue);
                });
                log(_debug, '[_PurchaseOverviewPageState.build] _filtered: ', _viewFilter);
                log(_debug, '[_PurchaseOverviewPageState.build] status List: ', _statusList);
              },
            ),
            const SizedBox(width: 4.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    if (
                      [UserGroupList.admin, UserGroupList.manager, UserGroupList.banned, UserGroupList.blocked]
                        .contains(userGroup.value)
                    )
                      Positioned(
                        bottom: 0.0,
                        width: 48.0,
                        child: Text(
                          userGroup.text(),
                          style: appThemeData.textTheme.caption!.copyWith(color: Colors.blue),
                          textScaleFactor: 0.8,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                        ),
                      ),
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
  List<String> _viewStatusList(AppUser user, ViewFilter viewFilter) {
    final userGroup = UserGroup(group: '${user['group']}').value;
    switch (viewFilter) {
      case ViewFilter.all:
        return [
          UserGroupList.normal, UserGroupList.vip1, UserGroupList.vip2, UserGroupList.vip3
        ].contains(userGroup)
          ? ['active', 'purchase', 'distribute', 'archived',]
          : ['prepare', 'active', 'purchase', 'distribute', 'archived', 'canceled',];
      case ViewFilter.prepare:
        return ['prepare',];
      case ViewFilter.active:
        return ['active', 'purchase', 'distribute',];
      case ViewFilter.purchase:
        return ['purchase',];
      case ViewFilter.distribute:
        return ['distribute',];
      case ViewFilter.archived:
        return ['archived',];
      case ViewFilter.canceled:
        return ['canceled',];
      default:
        return ['active',];
    }
  }
}
