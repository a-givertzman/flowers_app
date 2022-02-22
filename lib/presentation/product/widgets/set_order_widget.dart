import 'package:flowers_app/domain/order/order.dart';
import 'package:flowers_app/domain/purchase/purchase_product.dart';
import 'package:flowers_app/domain/purchase/purchase_status.dart';
import 'package:flowers_app/presentation/core/widgets/button_with_loading_indicator.dart';
import 'package:flowers_app/presentation/core/widgets/count_button.dart';
import 'package:flutter/material.dart';

class SetOrderWidget extends StatefulWidget {
  final int min;
  final int max;
  final PurchaseProduct product;
  final Function()? onComplete;
  const SetOrderWidget({
    Key? key,
    required this.min,
    required this.max,
    required this.product,
    this.onComplete,
  }) : super(key: key);
  @override
  _SetOrderWidgetState createState() => _SetOrderWidgetState();
}

class _SetOrderWidgetState extends State<SetOrderWidget> {
  int _count = 0;
  @override
  Widget build(BuildContext context) {
    // final status = 
    // final onOrder = 
    if (PurchaseStatusText(status: '${widget.product['status']}').onOrder()) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CountButton(
            min: widget.min, 
            max: widget.max,
            initialCount: int.tryParse('${widget.product['ordered_count']}') ?? 0,
            onChange: (count) => _count = count,
          ),
          ButtonWithLoadingIndicator(
            width: 110.0,
            height: 32.0,
            onSubmit: () => sendOrder(context, widget.product, _count)
              .then((response) {
                if (!response.hasError()) {
                  final onComplete = widget.onComplete;
                  if (onComplete != null) {
                    onComplete();
                  }
                }
                return response;
              }), 
            child: const Text('Ok'),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            'Заказы',
          ),
          Text(
            'приостановлены',
          ),
        ],
      );
    }
  }
}
