import 'package:flowers_app/domain/auth/app_user.dart';
import 'package:flowers_app/domain/notice/notice_list_viewed.dart';
import 'package:flowers_app/domain/purchase/purchase_product.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flowers_app/presentation/core/widgets/remains_widget.dart';
import 'package:flowers_app/presentation/product/product_page.dart';
import 'package:flowers_app/presentation/product/widgets/product_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
///
///
class PurchaseContentCard extends StatelessWidget {
  static const _log = Log('PurchaseContentCard');
  final AppUser _user;
  final PurchaseProduct purchaseProduct;
  final NoticeListViewed _noticeListViewed;
  ///
  ///
  const PurchaseContentCard({
    super.key,
    required AppUser user,
    required this.purchaseProduct,
    required NoticeListViewed noticeListViewed,
  }) : 
    _user = user,
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
                purchaseProduct: purchaseProduct,
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
                  ProductImageWidget(url: purchaseProduct.product_picture),
                  Positioned(
                    left: 16.0,
                    bottom: 16.0,
                    child: Container(
                      color: Colors.amberAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          purchaseProduct.status.text(), 
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
                              purchaseProduct.product_name,
                              textAlign: TextAlign.left,
                              style: appThemeData.textTheme.titleSmall,
                            ),
                            const SizedBox(height: 8,),
                            // Короткое описание товара (в списке отображается в одну строчку)
                            Text(
                              purchaseProduct.product_detales,
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
                            '${purchaseProduct.sale_price} ${purchaseProduct.sale_currency}',
                            textAlign: TextAlign.left,
                            style: appThemeData.textTheme.titleSmall,
                          ),
                          const SizedBox(height: 8,),
                          // Остаток товара (количество единиц доступное для заказа)
                          RemainsWidget(
                            caption: 'Остаток:   ',
                            value: purchaseProduct.remains,
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
