import 'package:flowers_app/assets/texts/app_text.dart';
import 'package:flowers_app/domain/purchase/purchase_item.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flowers_app/presentation/core/widgets/in_pogress_overlay.dart';
import 'package:flowers_app/presentation/core/widgets/remains_widget.dart';
import 'package:flowers_app/presentation/product/widgets/product_image_widget.dart';
import 'package:flowers_app/presentation/product/widgets/set_order_widget.dart';
import 'package:flutter/material.dart';
///
/// Displays a detailed info about the PurchaseItem
class ProductCard extends StatefulWidget {
  final String customerId;
  final PurchaseItem purchaseItem;
  ///
  ///
  const ProductCard({
    super.key,
    required this.customerId,
    required this.purchaseItem,
  });
  //
  //
  @override
  State<ProductCard> createState() => _ProductCardState();
}
//
//
class _ProductCardState extends State<ProductCard> {
  bool _isLoading = false;
  late PurchaseItem _purchaseItem;
  //
  //
  @override
  void initState() {
    _purchaseItem = widget.purchaseItem;
    if (!_purchaseItem.valid) {
      refreshPurchaseItem();
    }
    super.initState();
  }
  //
  //
  void refreshPurchaseItem() {
    setState(() {
      _isLoading = true;
    });
    _purchaseItem
      .refresh()
      .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
  }
  //
  //
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return InProgressOverlay(
        isSaving: _isLoading, 
        message: AppText.loading,
      );
    } else {
      return _buildProductCard(widget.purchaseItem);
    }
  }
  //
  //
  Widget _buildProductCard(PurchaseItem product) {
    return Card(
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ProductImageWidget(url: product.product_picture),
              SizedBox(
                width: double.infinity,
                // color: appThemeData.colorScheme.secondary,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.product_name,
                        textAlign: TextAlign.left,
                        style: appThemeData.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8,),
                      Text(
                        product.product_details,
                        textAlign: TextAlign.left,
                        style: appThemeData.textTheme.bodyMedium,
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
                                      'Цена за ед:   ${product.sale_price}',
                                      textAlign: TextAlign.left,
                                      style: appThemeData.textTheme.bodyMedium,
                                    ),
                                    const SizedBox(height: 24,),
                                    RemainsWidget(
                                      caption: 'Доступно:   ', 
                                      value: '${product.remains}',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8.0,),
                            SetOrderWidget(
                              customerId: widget.customerId,
                              product: product,
                              onComplete: () => refreshPurchaseItem(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Text(
                        product.product_description,
                        textAlign: TextAlign.left,
                        style: appThemeData.textTheme.bodyMedium,
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
