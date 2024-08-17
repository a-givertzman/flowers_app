import 'package:flowers_app/assets/texts/app_text.dart';
import 'package:flowers_app/domain/auth/app_user.dart';
import 'package:flowers_app/domain/notice/notice_list.dart';
import 'package:flowers_app/domain/notice/notice_list_viewed.dart';
import 'package:flowers_app/domain/order/order.dart';
import 'package:flowers_app/domain/order/order_header.dart';
import 'package:flowers_app/domain/order/order_list.dart';
import 'package:flowers_app/presentation/core/widgets/critical_error_widget.dart';
import 'package:flowers_app/presentation/core/widgets/in_pogress_overlay.dart';
import 'package:flowers_app/presentation/purchase/purchase_overview/widgets/error_purchase_card.dart';
import 'package:flowers_app/presentation/user_account/widgets/order_card.dart';
import 'package:flowers_app/presentation/user_account/widgets/order_header_card.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
///
///
class OrderOverviewBody extends StatelessWidget {
  static const _log = Log('OrderOverviewBody');
  final AppUser _user;
  final OrderList _orderList;
  final NoticeList _noticeList;
  final NoticeListViewed _noticeListViewed;
  ///
  ///
  const OrderOverviewBody({
    super.key,
    required AppUser user,
    required OrderList orderList,
    required NoticeList noticeList,
    required NoticeListViewed noticeListViewed,
  }) :
    _user = user, 
    _orderList = orderList, 
    _noticeList = noticeList, 
    _noticeListViewed = noticeListViewed;
  //
  //
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _orderList.refresh(),
      builder: (context, snapshot) {
        return RefreshIndicator(
          displacement: 20.0,
          onRefresh: _refreshAllLists,
          child: _buildListViewWidget(context, snapshot),
        );
      },
    );
  }
  ///
  ///
  Future<void> _refreshAllLists() {
    return Future(() {
      _log.debug('$OrderOverviewBody._refreshAllLists | orderList.refresh ...');
      _orderList.refresh()
        .then((value) {
          _log.debug('$OrderOverviewBody._refreshAllLists | noticeList.refresh ...');
          _noticeList.refresh(const NoticeListSqlParams());
        });
    });
  }
  ///
  ///
  Widget _buildListViewWidget(
    BuildContext context, 
    AsyncSnapshot<Result<Map<String, Order>, Failure>> snapshot,
  ) {
    switch (snapshot.data) {
      case null:
        _log.debug('$OrderOverviewBody._buildListView | is loading');
        return const InProgressOverlay(
          isSaving: true,
          message: AppText.loading,
        );
      case Ok<Map<String, Order>, Failure>(value: final ordersMap):
        final List<dynamic> orders = [];
        OrderHeader? orderHeader;
        String orderPurchaseId = '-1';
        for (final order in ordersMap.values) {
          if (order.purchase_id != orderPurchaseId) {
            orderPurchaseId = order.purchase_id;
              orderHeader = OrderHeader(
                order: order,
                total: 0,
                shipping: 0,
              );
              orders.add(orderHeader);
          }
          if (orderHeader != null) {
            orderHeader.addCost(
              order.getCost(),
              order.getShipping(),
            );
          }
          orders.add(order);
        }      
        _log.debug('$OrderOverviewBody._buildListView | orders received');
        return Scrollbar(
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              if (orders[index] is OrderHeader) {
                return OrderHeaderCard(
                  orderHeader: orders[index] as OrderHeader,
                );
              } else {
                final order = orders[index] as Order;
                if (order.valid) {
                  return OrderCard(
                    key: ValueKey(order.id),
                    user: _user,
                    order: order,
                    noticeList: _noticeList,
                    lastNotice: _noticeList.last(
                      fieldName: 'purchase_content_id', 
                      value: order.purchase_content_id,
                    ),
                    hasNotRead: _noticeList.hasNew(
                      fieldName: 'purchase_content_id', 
                      value: order.purchase_content_id,
                    ), 
                    noticeListViewed: _noticeListViewed,
                    onRemoved: () => _refreshAllLists(),
                  );
                } else {
                  return const ErrorPurchaseCard(message: 'Ошибка чтения списка заказов');
                }
              }
            },
          ),
        );
      case Err<Map<String, Order>, Failure>(:final error):
        _log.debug('$OrderOverviewBody._buildListView | Error: $error');
        return CriticalErrorWidget(
          message: snapshot.error.toString(),
          refresh: _refreshAllLists,
        );
    }
  }
}
