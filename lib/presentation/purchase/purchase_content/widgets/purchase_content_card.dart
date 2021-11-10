import 'package:flowers_app/assets/settings/common_settings.dart';
import 'package:flowers_app/assets/settings/purchase_list_setting.dart';
import 'package:flowers_app/domain/purchase/purchase_product.dart';
import 'package:flowers_app/infrastructure/api/app_data_source.dart';
import 'package:flowers_app/presentation/core/widgets/remains_widget.dart';
import 'package:flowers_app/presentation/product/product_page.dart';
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
      color: PurchaseListSetting.cardBodyBgColor,
      child: Dismissible(
        key: Key(purchaseProduct.id),
        background: Container(color: CommonUiSettings.deleteBgColor,),
        direction: DismissDirection.endToStart,
        confirmDismiss: (_) async {
          //TODO Confirm delete action to be implemented
          throw Exception('Confirm delete action to be implemented');
          return _showDeleteDialog(context);
        },
        onDismissed: (_) {
          //TODO Delete action to be implemented
          throw Exception('Celete action to be implemented');
          // final notesEvensBloc = BlocProvider.of<NotesEvensBloc>(context);
          // notesEvensBloc.add(NotesEvensEvent.deleted(note));
        },
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
                  Image.network(
                    '${purchaseProduct['product/picture']}',
                    loadingBuilder:(context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return SizedBox(
                        height: 400,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                          )
                        )
                      );
                    },
                    errorBuilder:(context, error, stackTrace) => 
                      Image.asset('assets/img/product-placeholder.jpg'),
                  ),
                // Container(
                //   color: PurchaseListSetting.cardBodyBgColor,
                //   child: Text(
                //     purchaseProduct['product/name'].toString(),
                //     style: Theme.of(context).textTheme.bodyText1
                //   ),
                // ),
                // const SizedBox(height: 8,),
                Container(
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.secondary, //PurchaseListSetting.cardTitleBgColor,
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
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              const SizedBox(height: 8,),
                              Text(
                                '${purchaseProduct['product/detales']}',
                                textAlign: TextAlign.left,
                                style: Theme.of(context).textTheme.bodyText2,
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
                              style: Theme.of(context).textTheme.subtitle1,
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
