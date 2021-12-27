import 'package:flowers_app/assets/texts/app_text.dart';
import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/auth/app_user.dart';
import 'package:flowers_app/domain/order/order.dart';
import 'package:flowers_app/domain/order/order_list.dart';
import 'package:flowers_app/presentation/core/widgets/critical_error_widget.dart';
import 'package:flowers_app/presentation/core/widgets/in_pogress_overlay.dart';
import 'package:flowers_app/presentation/purchase/purchase_overview/widgets/error_purchase_card.dart';
import 'package:flowers_app/presentation/user_account/widgets/order_card.dart';
import 'package:flutter/material.dart';

class OrderOverviewBody extends StatelessWidget {
  final AppUser user;
  final OrderList orderList;
  const OrderOverviewBody({
    Key? key,
    required this.user,
    required this.orderList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<dynamic>>(
      stream: orderList.dataStream,
      builder: (context, snapshot) {
        return RefreshIndicator(
          displacement: 20.0,
          onRefresh: orderList.refresh,
          child: _buildListViewWidget(context, snapshot),
        );
      },
    );
  }

  Widget _buildListViewWidget(
    BuildContext context, 
    AsyncSnapshot<List<dynamic>> snapshot,
  ) {
    final List<dynamic> orders = snapshot.data ?? List.empty();
    log('[$OrderOverviewBody._buildListView]');
    if (snapshot.hasError) {
      log('[$OrderOverviewBody._buildListView] snapshot hasError');
      return CriticalErrorWidget(
        message: snapshot.error.toString(),
        refresh: orderList.refresh,
      );
    } else if (snapshot.hasData) {
      log('[$OrderOverviewBody._buildListView] snapshot hasData');
      return Scrollbar(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index] as Order;
            if (order.valid()) {
              return OrderCard(
                key: ValueKey(order['id']),
                order: order,
              );
            } else {
              return const ErrorPurchaseCard(message: 'Ошибка чтения списка заказов');
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
