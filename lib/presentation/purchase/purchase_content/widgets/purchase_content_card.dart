import 'package:flowers_app/assets/settings/common_settings.dart';
import 'package:flowers_app/assets/settings/purchase_list_setting.dart';
import 'package:flowers_app/domain/purchase/purchase.dart';
import 'package:flowers_app/domain/purchase/purchase_product.dart';
import 'package:flutter/material.dart';

class PurchaseContentCard extends StatelessWidget {
  final PurchaseProduct purchaseProduct;

  const PurchaseContentCard({
    Key? key,
    required this.purchaseProduct,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: PurchaseListSetting.cardBodyBgColor,
      child: Dismissible(
        key: Key(purchaseProduct['id']),
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
            Navigator.pushNamed(context, '/second');
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  color: PurchaseListSetting.cardBodyBgColor,
                  child: Text(
                    purchaseProduct['product/name'] ?? 'В закупке пока нет товаров',
                    style: Theme.of(context).textTheme.bodyText1
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: PurchaseListSetting.cardTitleBgColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          purchaseProduct['product/name'] ?? 'Без имени',
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        const SizedBox(height: 8,),
                        Text(
                          purchaseProduct['product/detales'] ?? '',
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    ),
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
            purchaseProduct['product/name'] ?? 'Без имени',
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
