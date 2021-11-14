import 'package:flowers_app/assets/settings/common_settings.dart';
import 'package:flowers_app/assets/settings/purchase_list_setting.dart';
import 'package:flowers_app/domain/purchase/purchase_product.dart';
import 'package:flowers_app/infrastructure/api/responce.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flowers_app/presentation/core/widgets/remains_widget.dart';
import 'package:flowers_app/presentation/core/widgets/count_button.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final PurchaseProduct purchaseProduct;
  int _count = 0;
  Future<Response> Function(int) onSubmit;

  ProductCard({
    Key? key,
    required this.purchaseProduct,
    required this.onSubmit,
  }) : super(key: key);

  void _setCount(count) {
    _count = count;
  }

  @override
  Widget build(BuildContext context) {
    print('${purchaseProduct['product/picture']}');
    return Card(
      color: PurchaseListSetting.cardBodyBgColor,
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.network(
                '${purchaseProduct['product/picture']}',
                loadingBuilder:(context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return const SizedBox(
                    height: 400,
                    child: Center(
                      child: CircularProgressIndicator()
                    )
                  );
                },
                errorBuilder:(context, error, stackTrace) => 
                  Image.asset('assets/img/product-placeholder.jpg'),
              ),
              Container(
                width: double.infinity,
                color: appThemeData.colorScheme.secondary,
                // color: PurchaseListSetting.cardTitleBgColor,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${purchaseProduct['product/name']}',
                        textAlign: TextAlign.left,
                        style: appThemeData.textTheme.subtitle1,
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
                                children: [
                                  Text(
                                    'Цена за шт:   ${purchaseProduct['sale_price']}',
                                    textAlign: TextAlign.left,
                                    style: appThemeData.textTheme.subtitle1,
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
                                  min: 0, 
                                  max: int.parse('${purchaseProduct['remains']}'),
                                  onChange: (count) => _setCount(count),
                                ),
                                SizedBox(
                                  width: 110.0,
                                  height: 32.0,
                                  child: ButtonWithLoadingIndicator(
                                    count: _count,
                                    onSubmit: onSubmit, 
                                    onSuccess: (context) => 
                                      _showCompleteDialog(context),
                                    onFailure: (context, response) => 
                                      _showFailureDialog(context, response),
                                  ),
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
          content: Text(
            'Заказ успешно отправлен организаторам, вы можете скорректировать его в личном кабинете в любое время до блокировки закупки.',
            maxLines: 20,
            overflow: TextOverflow.clip,
            style: appThemeData.textTheme.bodyText1,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, true), 
              child: Text(
                'Ok',
                style: appThemeData.textTheme.subtitle2,
              ),
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
            style: appThemeData.textTheme.bodyText1,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false), 
              child: Text(
                'Ok',
                style: appThemeData.textTheme.subtitle2,
              ),
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

class ButtonWithLoadingIndicator extends StatefulWidget {
  const ButtonWithLoadingIndicator({
    Key? key,
    required int count,
    required this.onSubmit,
    required this.onSuccess,
    required this.onFailure,
  }) : _count = count, super(key: key);

  final Future<Response> Function(int count) onSubmit;
  final Function(BuildContext context) onSuccess;
  final Function(BuildContext context, Response response) onFailure;
  final int _count;

  @override
  State<ButtonWithLoadingIndicator> createState() => _ButtonWithLoadingIndicatorState();
}

class _ButtonWithLoadingIndicatorState extends State<ButtonWithLoadingIndicator> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return _isLoading
      ? const SizedProgressIndicator(
        height: 24.0,
        width: 24.0,
      )
      : TextButton(
        child: const Text('Применить'),
        onPressed: () {
          setState(() {
            _isLoading = true;
          });
          print('loading...');
          widget.onSubmit(widget._count).then((response) {
            if (response.hasError()) {
              setState(() {
                _isLoading = false;
              });
              print(response.errorMessage());
              widget.onFailure(context, response);
            } else if (response.hasData()) {
              setState(() {
                _isLoading = false;
              });
              print(response.data());
              widget.onSuccess(context);
            }
          });
        },
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xffFF8426),
        ),
      );
  }
}

class SizedProgressIndicator extends StatelessWidget {
  final double _height;
  final double _width;
  const SizedProgressIndicator({
    Key? key,
    required double width,
    required double height,
  }) : 
    _width = width,
    _height = height,
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          child: const CircularProgressIndicator(),
          width: _width,
          height: _height,
        ),
    );
  }
}

