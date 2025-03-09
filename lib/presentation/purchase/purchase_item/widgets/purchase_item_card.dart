import 'package:flower_app/domain/auth/app_user.dart';
import 'package:flower_app/domain/notice/notice_list.dart';
import 'package:flower_app/domain/notice/notice_list_viewed.dart';
import 'package:flower_app/domain/purchase/purchase_item.dart';
import 'package:flower_app/presentation/core/app_theme.dart';
import 'package:flower_app/presentation/core/widgets/remains_widget.dart';
import 'package:flower_app/presentation/product/product_page.dart';
import 'package:flower_app/presentation/product/widgets/product_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
///
///
class PurchaseItemCard extends StatelessWidget {
  static const _log = Log('PurchaseItemCard');
  final AppUser _user;
  final PurchaseItem purchaseItem;
  final NoticeList _noticeList;
  final NoticeListViewed _noticeListViewed;
  ///
  ///
  PurchaseItemCard({
    super.key,
    required AppUser user,
    required this.purchaseItem,
    required NoticeListViewed noticeListViewed,
  }) : 
    _user = user,
    _noticeList = NoticeList(noticeListViewed: noticeListViewed),
    _noticeListViewed = noticeListViewed;
  //
  //
  @override
  Widget build(BuildContext context) {
    _log.debug('._build |');
    return Card(
      color: appThemeData.colorScheme.secondary,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>  ProductPage(
                user: _user,
                purchaseItem: purchaseItem,
                noticeList: _noticeList,
                noticeListViewed: _noticeListViewed,
              ),
              settings: const RouteSettings(name: "/productPage"),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: [
                  ProductImageWidget(url: purchaseItem.product_picture),
                  Positioned(
                    left: 16.0,
                    bottom: 16.0,
                    child: Container(
                      color: Colors.amberAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          purchaseItem.status.text(), 
                          textScaler: const TextScaler.linear(1.1),
                          style: appThemeData.textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 16.0,
                    bottom: 16.0,
                    width: 42.0,
                    height: 42.0,
                    child: Image.asset(
                      'assets/icons/cart-icon.png',
                      color: appThemeData.colorScheme.tertiary,
                      colorBlendMode: BlendMode.modulate,
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                color: appThemeData.colorScheme.secondary,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Наименование товара
                            Text(
                              purchaseItem.product_name,
                              textAlign: TextAlign.left,
                              style: appThemeData.textTheme.titleSmall,
                            ),
                            const SizedBox(height: 8,),
                            // Короткое описание товара (в списке отображается в одну строчку)
                            Text(
                              purchaseItem.product_details,
                              textAlign: TextAlign.left,
                              style: appThemeData.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Цена за единицу
                          Text(
                            '${purchaseItem.sale_price} ${purchaseItem.sale_currency}',
                            textAlign: TextAlign.left,
                            style: appThemeData.textTheme.titleSmall,
                          ),
                          const SizedBox(height: 8,),
                          // Остаток товара (количество единиц доступное для заказа)
                          RemainsWidget(
                            caption: 'Остаток:   ',
                            value: '${purchaseItem.remains}',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
