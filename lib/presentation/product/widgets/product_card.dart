import 'package:flowers_app/domain/purchase/purchase_product.dart';
import 'package:flowers_app/infrastructure/api/responce.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flowers_app/presentation/core/widgets/remains_widget.dart';
import 'package:flowers_app/presentation/core/widgets/count_button.dart';
import 'package:flowers_app/presentation/core/widgets/button_with_loading_indicator.dart';
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

  void _setCount(count) {
    _count = count;
  }
  Future<Response> _sendOrder(BuildContext context, PurchaseProduct product,  int count) {
    print('loading...');
    return product.sendOrder(count).then((response) {
      if (response.hasError()) {
        print(response.errorMessage());
        _showFailureDialog(context, response);
      } else if (response.hasData()) {
        print(response.data());
        _showCompleteDialog(context);
      }
      return response;
    });
  }
  @override
  Widget build(BuildContext context) {
    print('${purchaseProduct['product/picture']}');
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 12.0,
                                left: 8.0
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Цена за шт:   ${purchaseProduct['sale_price']}',
                                    textAlign: TextAlign.left,
                                    style: appThemeData.textTheme.bodyText2,
                                  ),
                                  const SizedBox(height: 24,),
                                  RemainsWidget(
                                    caption: 'Доступно для заказа:   ', 
                                    value: '${purchaseProduct['remains']}',
                                  )
                                ],
                              ),
                            ),
                            Column(
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

  void _showCompleteDialog(BuildContext context) {
    showDialog<bool>(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ваш заказ отправлен'),
          content: const Text(
            'Заказ успешно отправлен организаторам, вы можете скорректировать его в личном кабинете в любое время до блокировки закупки.',
            maxLines: 20,
            overflow: TextOverflow.clip,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, true), 
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  void _showFailureDialog(BuildContext context, Response response) {
    showDialog<bool>(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ошибка'),
          content: Text('''
В процессе размещение заказа возникла ошибка: ${response.errorMessage()}
\nПроверьте интернет соединение или nопробуйте позже.
\nПриносим извинения за неудобства.''',
            maxLines: 20,
            overflow: TextOverflow.clip,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false), 
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showDeleteDialog(BuildContext context, PurchaseProduct product) {
    return showDialog<bool>(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Удалить заказ?'),
          content: Text(
            product['product/name'].toString(),
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
