import 'package:flowers_app/assets/texts/app_text.dart';
import 'package:flowers_app/domain/notice/notice.dart';
import 'package:flowers_app/domain/notice/notice_list.dart';
import 'package:flowers_app/domain/notice/notice_list_viewed.dart';
import 'package:flowers_app/domain/purchase/purchase_product.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flowers_app/presentation/core/widgets/in_pogress_overlay.dart';
import 'package:flowers_app/presentation/core/widgets/remains_widget.dart';
import 'package:flowers_app/presentation/notice/widgets/notice_overview_body.dart';
import 'package:flowers_app/presentation/product/widgets/product_image_widget.dart';
import 'package:flowers_app/presentation/product/widgets/set_order_widget.dart';
import 'package:flutter/material.dart';

class ProductCardWithNotices extends StatefulWidget {
  final PurchaseProduct purchaseProduct;
  final NoticeList _noticeList;
  final NoticeListViewed noticeListViewed;
  final Future<bool> hasNotRead;
  ProductCardWithNotices({
    Key? key,
    required this.purchaseProduct,
    NoticeList? noticeList,
    required this.hasNotRead,
    required this.noticeListViewed,
  }) :
    _noticeList = noticeList ?? NoticeList.empty(),
    super(key: key);
  @override
  State<ProductCardWithNotices> createState() => _ProductCardWithNoticesState();
}

class _ProductCardWithNoticesState extends State<ProductCardWithNotices> {
  late Notice _lastNotice = Notice.empty();
  late PurchaseProduct _purchaseProduct;
  late NoticeListViewed _noticeListViewed;
  bool _isLoading = true;
  bool _expandedDescription = false;
  bool _expandedNoticeList = false;
  bool _hasNotRead = false;
  bool _lastNoticeHasError = false;
  @override
  void initState() {
    _purchaseProduct = widget.purchaseProduct;
    _noticeListViewed = widget.noticeListViewed;
    refreshPurchaseProduct();
    super.initState();
  }
  void refreshPurchaseProduct() {
    setState(() {
      _isLoading = true;
    });
    widget
      ._noticeList
      .last(
        fieldName: 'purchase_content/id', 
        value: '${_purchaseProduct['purchase_content/id']}',
      )
      .then((value) {
        setState(() {
          _lastNotice = value;
        });
      })
      .onError((error, stackTrace) {
        setState(() {
          _lastNoticeHasError = true;
        });
      });
    widget.hasNotRead
      .then((value) {
        setState(() {
          _hasNotRead = value;
        });
      });
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
      return _buildProductCardNotified(_purchaseProduct);
    }
  }
  Widget _buildProductCardNotified(PurchaseProduct product) {
    return Card(
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ProductImageWidget(url: '${product['product/picture']}'),
              SizedBox(
                width: double.infinity,
                // color: appThemeData.colorScheme.secondary,
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
                    ],
                  ),
                ),
              ),
              Container(height: 1, color: appThemeData.colorScheme.primaryContainer,),
              ExpansionPanelList(
                animationDuration: const Duration(milliseconds: 1000),
                dividerColor: appThemeData.colorScheme.primaryContainer,
                elevation: 1.0,
                expandedHeaderPadding: const EdgeInsets.all(0.1),
                expansionCallback: (panelIndex, isExpanded) => setState(() {
                  switch (panelIndex) {
                    case 0 :
                      _expandedDescription = !_expandedDescription;
                      break;
                    case 1 :
                      _expandedNoticeList = !_expandedNoticeList;
                      break;
                    default:
                  }
                }),
                children: [
                  ExpansionPanel(
                    isExpanded: _expandedDescription,
                    // backgroundColor: appThemeData.colorScheme.primaryContainer,
                    headerBuilder: (context, isExpanded) => _buildDescriptionPanelHeader(
                      context, 
                      isExpanded, 
                      '${product['product/description']}',
                    ),
                    body: Container(
                      decoration: const BoxDecoration(
                        border: Border.symmetric(
                          // vertical: BorderSide(width: 6.0, color: appThemeData.colorScheme.primaryContainer,),
                        ),
                        // color: appThemeData.colorScheme.secondary,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0, bottom: 16,),
                        child: Text(
                          '${product['product/description']}',
                          textAlign: TextAlign.left,
                          style: appThemeData.textTheme.bodyText2,
                        ),
                      ),
                    ),
                  ),
                  ExpansionPanel(
                    isExpanded: _expandedNoticeList,
                    // backgroundColor: appThemeData.colorScheme.primaryContainer,
                    headerBuilder: (context, isExpanded) => _buildNoticeListHeader(
                      context, 
                      isExpanded, 
                      _lastNotice,
                    ),
                    body: Container(
                      decoration: const BoxDecoration(
                        border: Border.symmetric(
                          // vertical: BorderSide(width: 6.0, color: appThemeData.colorScheme.primaryContainer,),
                        ),
                        // color: appThemeData.colorScheme.secondary,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0, bottom: 16,),
                        child: NoticeOverviewBody(
                          // user: user, 
                          purchaseContentId: '${product['purchase_content/id']}',
                          noticeList: widget._noticeList,
                          enableUserMessage: false,
                          noticeListViewed: _noticeListViewed,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildDescriptionPanelHeader(BuildContext context, bool isExpanded, String description) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: isExpanded
        ? Text(
          'Свернуть описание',
          textAlign: TextAlign.left,
          style: appThemeData.textTheme.bodyText2,
        )
        : Text(
          description,
          textAlign: TextAlign.left,
          style: appThemeData.textTheme.bodyText2,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
    );
  }
  Widget _buildNoticeListHeader(BuildContext context, bool isExpanded, Notice lastNotice) {
    String _message = '';
    if (isExpanded) {
      _message = 'Свернуть сообщения';
    } else {
      if (lastNotice.isEmpty) {
        _message = AppText.noNotines;
      } else {
        _message = '${lastNotice['message']}';
      }
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            _lastNoticeHasError
              ? Icons.error_outline
              : _message == AppText.noNotines
                ? Icons.messenger_outline
                : Icons.message_outlined,
            size: baseFontSize * 1.3,
            color: _lastNoticeHasError
            ? appThemeData.errorColor 
            : _hasNotRead
              ? Colors.blue
              : Colors.grey,
          ),
          const SizedBox(width: 4.0,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _message,
                  textAlign: TextAlign.left,
                  style: appThemeData.textTheme.subtitle2,
                ),
              if (!lastNotice.isEmpty && !isExpanded)
                const SizedBox(height: 4,),
              if (!lastNotice.isEmpty  && !isExpanded)
                Text(
                  '${lastNotice['updated']}',
                  textAlign: TextAlign.left,
                  style: appThemeData.textTheme.caption,
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
