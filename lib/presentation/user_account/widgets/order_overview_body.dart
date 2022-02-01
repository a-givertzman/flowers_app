import 'package:flowers_app/assets/texts/app_text.dart';
import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/auth/app_user.dart';
import 'package:flowers_app/domain/notice/notice_list.dart';
import 'package:flowers_app/domain/order/order.dart';
import 'package:flowers_app/domain/order/order_header.dart';
import 'package:flowers_app/domain/order/order_list.dart';
import 'package:flowers_app/presentation/core/widgets/critical_error_widget.dart';
import 'package:flowers_app/presentation/core/widgets/in_pogress_overlay.dart';
import 'package:flowers_app/presentation/purchase/purchase_overview/widgets/error_purchase_card.dart';
import 'package:flowers_app/presentation/user_account/widgets/order_card.dart';
import 'package:flowers_app/presentation/user_account/widgets/order_header_card.dart';
import 'package:flutter/material.dart';

class OrderOverviewBody extends StatelessWidget {
  final AppUser user;
  final OrderList orderList;
  final NoticeList noticeList;
  const OrderOverviewBody({
    Key? key,
    required this.user,
    required this.orderList,
    required this.noticeList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Order>>(
      stream: orderList.dataStream,
      builder: (context, snapshot) {
        return RefreshIndicator(
          displacement: 20.0,
          onRefresh: _refreshAllLists,
          child: _buildListViewWidget(context, snapshot),
        );
      },
    );
  }
  Future<void> _refreshAllLists() {
    return Future(() {
      noticeList.fetchWith(params: {
        'client_id': '${user['id']}',
      },);
      orderList.refresh();
    });
  }
  Widget _buildListViewWidget(
    BuildContext context, 
    AsyncSnapshot<List<Order>> snapshot,
  ) {
    final _orders = snapshot.data ?? [];
    final List<dynamic> orders = [];
    OrderHeader? orderHeader;
    String orderPurchaseId = '-1';
    for (final _order in _orders) {
      if ('${_order['purchase/id']}' != orderPurchaseId) {
        orderPurchaseId = '${_order['purchase/id']}';
          orderHeader = OrderHeader(
            order: _order,
            total: 0,
          );
          orders.add(orderHeader);
      }
      if (orderHeader != null) {
        orderHeader.addCost(double.parse('${_order['cost']}'));
      }
      orders.add(_order);
    }
    log('[$OrderOverviewBody._buildListView]');
    if (snapshot.hasError) {
      log('[$OrderOverviewBody._buildListView] snapshot hasError');
      return CriticalErrorWidget(
        message: snapshot.error.toString(),
        refresh: _refreshAllLists,
      );
    } else if (snapshot.hasData) {
      log('[$OrderOverviewBody._buildListView] snapshot hasData');
      return Scrollbar(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            if (orders[index] is OrderHeader) {
              return OrderHeaderCard(
                orderHeader: orders[index] as OrderHeader,
              );
            } else {
              final order = orders[index] as Order;
              // final notice = noticeList.lastByValue(
              //   fieldName: 'purchase_content/id',
              //   value: '${order['purchase_content/id']}',
              // );
              if (order.valid()) {
                // final _noticeStream = _noticeListStream.map(
                //   (event) {
                //     return event.firstWhere(
                //       (element) => '${element['purchase_content/id']}' == '${order['purchase_content/id']}',
                //     );
                //   }
                // );
                return OrderCard(
                  key: ValueKey(order['id']),
                  order: order,
                  noticeStream: noticeList.noticeStream,
                );
              } else {
                return const ErrorPurchaseCard(message: 'Ошибка чтения списка заказов');
              }
            }
          },
        ),
      );
    } else {
      log('[$OrderOverviewBody._buildListView] is loading');
      return const InProgressOverlay(
        isSaving: true,
        message: AppText.loading,
      );
    }
  }
}
