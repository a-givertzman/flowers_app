// ignore_for_file: use_setters_to_change_properties

import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/purchase/purchase_product.dart';
import 'package:flowers_app/infrastructure/api/response.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flowers_app/presentation/core/dialigs/complete_dialog.dart';
import 'package:flowers_app/presentation/core/dialigs/failore_dialog.dart';
import 'package:flowers_app/presentation/core/widgets/button_with_loading_indicator.dart';
import 'package:flowers_app/presentation/core/widgets/count_button.dart';
import 'package:flowers_app/presentation/core/widgets/remains_widget.dart';
import 'package:flowers_app/presentation/product/widgets/product_image_widget.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final PurchaseProduct purchaseProduct;
  int _count = 0;

  ProductCard({
    Key? key,
    required this.purchaseProduct,
    // required this.onSubmit,
  }) : super(key: key);

  void _setCount(int count) {
    _count = count;
  }
  Future<Response<Map>> _sendOrder(BuildContext context, PurchaseProduct product,  int count) {
    log('[ProductCard._sendOrder] loading...');
    return product.sendOrder(count).then((response) {
      if (response.hasError()) {
        log('[ProductCard._sendOrder] response.error: ', response.errorMessage());
        showFailureDialog(
          context,
          title: const Text('Ошибка'),
          content: Text('''
В процессе размещение заказа возникла ошибка: ${response.errorMessage()}
\nПроверьте интернет соединение или nопробуйте позже.
\nПриносим извинения за неудобства.''',
            maxLines: 20,
            overflow: TextOverflow.clip,
          ),
        );
      } else if (response.hasData()) {
        showCompleteDialog(
          context,
          title: const Text('Ваш заказ отправлен'),
          content: const Text(
            'Заказ успешно отправлен организаторам, вы можете скорректировать его в личном кабинете в любое время до блокировки закупки.',
            maxLines: 20,
            overflow: TextOverflow.clip,
          ),
        );
      }
      return response;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ProductImageWidget(purchaseProduct: purchaseProduct),
              Container(
                width: double.infinity,
                color: appThemeData.colorScheme.secondary,
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
                      const SizedBox(height: 12,),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 8.0,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 12.0,
                                  left: 8.0,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Цена за шт:   ${purchaseProduct['sale_price']}',
                                      textAlign: TextAlign.left,
                                      style: appThemeData.textTheme.bodyText2,
                                    ),
                                    const SizedBox(height: 24,),
                                    RemainsWidget(
                                      caption: 'Доступно:   ', 
                                      value: '${purchaseProduct['remains']}',
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8.0,),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CountButton(
                                  min: 1, 
                                  max: int.parse('${purchaseProduct['remains']}'),
                                  onChange: (count) => _setCount(count),
                                ),
                                ButtonWithLoadingIndicator(
                                  width: 110.0,
                                  height: 32.0,
                                  onSubmit: () => _sendOrder(context, purchaseProduct, _count), 
                                  child: const Text('Ok'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Text(
                        '${purchaseProduct['product/description']}',
                        textAlign: TextAlign.left,
                        style: appThemeData.textTheme.bodyText2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
