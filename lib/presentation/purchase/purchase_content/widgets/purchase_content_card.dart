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
    print(purchaseProduct['product/picture'].toString());
    return Card(
      color: appThemeData.colorScheme.secondary,
      child: InkWell(
        onTap: () {
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) =>  ProductPage(
                  product: purchaseProduct,
                  dataSource: dataSource,
                ),
              )              
            );
        },
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ProductImageWidget(purchaseProduct: purchaseProduct),
              // Container(
              //   color: PurchaseListSetting.cardBodyBgColor,
              //   child: Text(
              //     purchaseProduct['product/name'].toString(),
              //     style: appThemeData.textTheme.bodyText1
              //   ),
              // ),
              // const SizedBox(height: 8,),
              Container(
                width: double.infinity,
                color: appThemeData.colorScheme.secondary,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
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

  Future<bool?> _showDeleteDialog(BuildContext context) {
    return showDialog<bool>(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Удалить заметку?'),
          content: Text(
            purchaseProduct['product/name'].toString(),
            maxLines: 2,
            overflow: TextOverflow.clip,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false), 
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true), 
              child: const Text('Удалить'),
            ),
          ],
        );
      },
    );
  }
}
