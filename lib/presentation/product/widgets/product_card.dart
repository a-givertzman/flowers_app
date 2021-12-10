import 'package:flowers_app/assets/texts/app_text.dart';
import 'package:flowers_app/domain/purchase/purchase_product.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flowers_app/presentation/core/widgets/in_pogress_overlay.dart';
import 'package:flowers_app/presentation/core/widgets/remains_widget.dart';
import 'package:flowers_app/presentation/product/widgets/product_image_widget.dart';
import 'package:flowers_app/presentation/product/widgets/set_order_widget.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final PurchaseProduct purchaseProduct;
  const ProductCard({
    Key? key,
    required this.purchaseProduct,
  }) : super(key: key);
  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isLoading = true;
  late PurchaseProduct _purchaseProduct;
  @override
  void initState() {
    _isLoading = true;
    _purchaseProduct = widget.purchaseProduct;
    refreshPurchaseProduct();
    super.initState();
  }
  void refreshPurchaseProduct() {
    _purchaseProduct
      .refresh()
      .then((purchaseProduct) {
        setState(() {
          _purchaseProduct = purchaseProduct as PurchaseProduct;
          _isLoading = false;
        });
      });
  }
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return InProgressOverlay(
        isSaving: _isLoading, 
        message: AppText.loading,
      );
    } else {
      return _buildProductCard(widget.purchaseProduct);
    }
  }
  Widget _buildProductCard(PurchaseProduct product) {
    return Card(
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ProductImageWidget(purchaseProduct: product),
              Container(
                width: double.infinity,
                color: appThemeData.colorScheme.secondary,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${product['product/name']}',
                        textAlign: TextAlign.left,
                        style: appThemeData.textTheme.subtitle2,
                      ),
                      const SizedBox(height: 8,),
                      Text(
                        '${product['product/detales']}',
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
                                      'Цена за шт:   ${product['sale_price']}',
                                      textAlign: TextAlign.left,
                                      style: appThemeData.textTheme.bodyText2,
                                    ),
                                    const SizedBox(height: 24,),
                                    RemainsWidget(
                                      caption: 'Доступно:   ', 
                                      value: '${product['remains']}',
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8.0,),
                            SetOrderWidget(
                              min: 0,
                              max: int.parse('${product['remains']}'),
                              product: product,
                              onComplete: () => refreshPurchaseProduct(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Text(
                        '${product['product/description']}',
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
