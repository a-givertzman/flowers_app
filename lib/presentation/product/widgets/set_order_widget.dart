import 'package:flowers_app/domain/purchase/purchase_product.dart';
import 'package:flowers_app/domain/purchase/purchase_set_order.dart';
import 'package:flowers_app/presentation/core/widgets/button_with_loading_indicator.dart';
import 'package:flowers_app/presentation/core/widgets/count_button.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/src/core/error/failure.dart';
import 'package:hmi_core/src/core/result_new/result.dart';
///
///
class SetOrderWidget extends StatefulWidget {
  final int min;
  final int? max;
  final String customerId;
  final PurchaseProduct product;
  final Function()? onComplete;
  ///
  ///
  const SetOrderWidget({
    super.key,
    this.min = 0,
    this.max,
    required this.customerId,
    required this.product,
    this.onComplete,
  });
  //
  //
  @override
  _SetOrderWidgetState createState() => _SetOrderWidgetState();
}
//
//
class _SetOrderWidgetState extends State<SetOrderWidget> {
  static const _log = Log('_SetOrderWidgetState');
  bool _isLoadingAmount = false;
  int _count = 0;
  //
  //
  @override
  void initState() {
    if (widget.max == null) {
      widget.product.fetch().then((result) {
        setState(() {
          _isLoadingAmount = true;
        });
      });
    }
    super.initState();
  }
  //
  //
  @override
  Widget build(BuildContext context) {
    if (widget.product.status.isOrder()) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isLoadingAmount)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width:  Theme.of(context).iconTheme.size ?? 24.0,
                height: Theme.of(context).iconTheme.size ?? 24.0,
                child: const CircularProgressIndicator(),
              ),
            )
          else
            CountButton(
              min: widget.min, 
              max: widget.max ?? int.tryParse(widget.product.amount) ?? 0,
              initialCount: int.tryParse(widget.product.amount) ?? 0,
              onChange: (count) => _count = count,
            ),
          ButtonWithLoadingIndicator(
            width: 110.0,
            height: 32.0,
            onSubmit: () => PurchaseSetOrder(customerId: widget.customerId).send('$_count', widget.product.id, widget.product.product_id, widget.product.purchase_id)
              .then((result) {
                switch (result) {
                  case Ok<Map<String, dynamic>, Failure>(value: final _):
                    final onComplete = widget.onComplete;
                    if (onComplete != null) {
                      onComplete();
                    }
                  case Err<Map<String, dynamic>, Failure>(: final error):
                    _log.warning('.build | PurchaseSetOrder Error: $error');
                    // TODO: Handle this case.
                }
                return result;
              }), 
            child: const Text('Ok'),
          ),
        ],
      );
      // return Column(
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     CountButton(
      //       min: widget.min, 
      //       max: _max,
      //       initialCount: int.tryParse('${widget.product['ordered_count']}') ?? 0,
      //       onChange: (count) => _count = count,
      //     ),
      //     ButtonWithLoadingIndicator(
      //       width: 110.0,
      //       height: 32.0,
      //       onSubmit: () => sendOrder(context, widget.product, _count)
      //         .then((response) {
      //           if (!response.hasError()) {
      //             final onComplete = widget.onComplete;
      //             if (onComplete != null) {
      //               onComplete();
      //             }
      //           }
      //           return response;
      //         }), 
      //       child: const Text('Ok'),
      //     ),
      //   ],
      // );
    } else {
      final style = DefaultTextStyle.of(context).style;
      final color = DefaultTextStyle.of(context).style.color;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Заказы',
          ),
          const Text(
            'приостановлены',
          ),
          Text(
            style: style.copyWith(color: color?.withOpacity(0.5)),
            widget.product.status.text(),
          ),
        ],
      );
    }
  }
}
