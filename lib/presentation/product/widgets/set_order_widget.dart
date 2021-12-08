import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/purchase/purchase_product.dart';
import 'package:flowers_app/infrastructure/api/response.dart';
import 'package:flowers_app/presentation/core/dialigs/complete_dialog.dart';
import 'package:flowers_app/presentation/core/dialigs/failure_dialog.dart';
import 'package:flowers_app/presentation/core/widgets/button_with_loading_indicator.dart';
import 'package:flowers_app/presentation/core/widgets/count_button.dart';
import 'package:flutter/material.dart';

class SetOrderWidget extends StatefulWidget {
  final int min;
  final int max;
  final PurchaseProduct product;
  const SetOrderWidget({
    Key? key,
    required this.min,
    required this.max,
    required this.product,
  }) : super(key: key);

  @override
  _SetOrderWidgetState createState() => _SetOrderWidgetState();
}

class _SetOrderWidgetState extends State<SetOrderWidget> {
  int _count = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CountButton(
          min: widget.min, 
          max: widget.max,
          onChange: (count) => _count = count,
        ),
        ButtonWithLoadingIndicator(
          width: 110.0,
          height: 32.0,
          onSubmit: () => _sendOrder(context, widget.product, _count), 
          child: const Text('Ok'),
        ),
      ],
    );
  }
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