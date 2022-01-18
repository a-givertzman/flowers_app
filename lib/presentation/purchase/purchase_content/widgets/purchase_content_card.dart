import 'package:flowers_app/domain/purchase/purchase_product.dart';
import 'package:flowers_app/infrastructure/datasource/app_data_source.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flowers_app/presentation/core/widgets/remains_widget.dart';
import 'package:flowers_app/presentation/product/product_page.dart';
import 'package:flowers_app/presentation/product/widgets/product_image_widget.dart';
import 'package:flutter/material.dart';

class PurchaseContentCard extends StatelessWidget {
  final PurchaseProduct purchaseProduct;

  const PurchaseContentCard({
    Key? key,
    required this.purchaseProduct,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: appThemeData.colorScheme.secondary,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>  ProductPage(
                product: purchaseProduct,
                dataSource: dataSource,
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
                  ProductImageWidget(url: '${purchaseProduct['product/picture']}'),
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
                            Text(
                              '${purchaseProduct['product/name']}',
                              textAlign: TextAlign.left,
                              style: appThemeData.textTheme.subtitle2,
                            ),
                            const SizedBox(height: 8,),
                            Text(
                              '${purchaseProduct['product/detales']}',
                              textAlign: TextAlign.left,
                              style: appThemeData.textTheme.bodyText2,
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
                          Text(
                            '${purchaseProduct['sale_price']} ${purchaseProduct['sale_currency']}',
                            textAlign: TextAlign.left,
                            style: appThemeData.textTheme.subtitle2,
                          ),
                          const SizedBox(height: 8,),
                          RemainsWidget(
                            caption: 'Остаток:   ',
                            value: '${purchaseProduct['remains']}',
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
