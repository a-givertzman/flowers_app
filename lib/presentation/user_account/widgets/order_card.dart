import 'package:flowers_app/domain/auth/app_user.dart';
import 'package:flowers_app/domain/notice/notice.dart';
import 'package:flowers_app/domain/notice/notice_list.dart';
import 'package:flowers_app/domain/notice/notice_list_viewed.dart';
import 'package:flowers_app/domain/order/order.dart';
import 'package:flowers_app/domain/purchase/purchase_product.dart';
import 'package:flowers_app/domain/purchase/purchase_status.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flowers_app/presentation/core/dialogs/delete_dialog.dart';
import 'package:flowers_app/presentation/core/widgets/sized_progress_indicator.dart';
import 'package:flowers_app/presentation/product/product_page.dart';
import 'package:flowers_app/presentation/user_account/widgets/last_notice_tile.dart';
import 'package:flowers_app/presentation/user_account/widgets/order_tile_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
///
///
class OrderCard extends StatefulWidget {
  final AppUser user;
  final Order order;
  final NoticeList noticeList;
  final Future<Notice> lastNotice;
  final Future<bool> hasNotRead;
  final NoticeListViewed noticeListViewed;
  final void Function() onRemoved;
  ///
  ///
  const OrderCard({
    super.key,
    required this.user,
    required this.order,
    required this.noticeList,
    required this.lastNotice,
    required this.hasNotRead,
    required this.noticeListViewed,
    required this.onRemoved,
  });
  //
  //
  @override
  State<OrderCard> createState() => _OrderCardState();
}
///
///
class _OrderCardState extends State<OrderCard> {
  bool _isLoading = true;
  late Order _order;
  late NoticeList _noticeList;
  late NoticeListViewed _noticeListViewed;
  late void Function() _onRemoved;
  //
  //
  @override
  void initState() {
    _isLoading = false;
    _order = widget.order;
    _noticeList = widget.noticeList;
    _noticeListViewed = widget.noticeListViewed;
    _onRemoved = widget.onRemoved;
    super.initState();
  }
  //
  //
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedProgressIndicator(
        height: 40.0,
        width: 40.0,
      );
    } else {
      return _buildOrderTile(_order, _noticeList);
    }
  }
  //
  //
  Widget _buildOrderTile(Order order, NoticeList noticeList) {
    return InkWell(
      onTap: () {
        final product = PurchaseProduct(
          // userId: order.customer_id,
          purchaseContentId: order.purchase_content_id,
        );
        product.product_name = order.product_name;
        product.purchase_id = order.purchase_id;
        product.status = order.purchase_content_status;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductPage(
              user: widget.user,
              purchaseProduct: product,
              noticeList: noticeList, 
              noticeListViewed: _noticeListViewed,
            ),
            settings: const RouteSettings(name: "/productPage"),
          ),
        ).then((_) {
          setState(() {
            _isLoading = true;
            order.fetch(order.id).then((response) {
              setState(() {
                _isLoading = false;
              });
            });
          });
        });        
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              child: IntrinsicHeight(
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 24.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: OrderTileImageWidget(
                          url: order.product_picture,
                          radius: 36.0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0,),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0, 
                          top: 12.0,
                          right: 4.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.product_name,
                              softWrap: true,
                              overflow: TextOverflow.visible,
                              style: appThemeData.textTheme.titleSmall,
                            ),
                            const SizedBox(height: 8.0,),
                            Text(
                              order.product_group,
                              style: appThemeData.textTheme.bodySmall,
                            ),
                            const SizedBox(height: 12.0,),
                            LastNoticeTile(
                              key: ValueKey(order.id),
                              lastNotice: widget.lastNotice,
                              hasNotRead: widget.hasNotRead,
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      iconSize: 18.0,
                      splashRadius: 20.0,
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        showDeleteDialog(
                          context, 
                          Text(order.product_name), 
                          const Text('Удалить заказ ?'),
                        ).then((result) {
                          if (result != null && result) {
                            order.remove(context).then((result) {
                              if (result case Ok(value:final _)) {
                                _onRemoved();
                              }
                            });
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 12.0,
                  ),
                  child: Text(
                    PurchaseStatus(status: order.purchase_content_status).text(),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 4.0,
                      left: 8.0,
                      right: 8.0,
                      bottom: 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          order.cost,
                          style: appThemeData.textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8,),
                        Text(
                          '${order.count}x(${order.purchase_content_sale_price} + ${order.purchase_content_shipping})',
                          style: appThemeData.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
