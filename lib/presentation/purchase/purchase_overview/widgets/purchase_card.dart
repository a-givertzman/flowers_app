import 'package:flowers_app/domain/purchase/purchase.dart';
import 'package:flowers_app/domain/user/user.dart';
import 'package:flowers_app/infrastructure/api/app_data_source.dart';
import 'package:flowers_app/presentation/purchase/purchase_content/purchase_content_page.dart';
import 'package:flutter/material.dart';

class PurchaseCard extends StatelessWidget {
  final User user;
  final Purchase purchase;

  const PurchaseCard({
    Key? key,
    required this.user,
    required this.purchase,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print('[PurchaseCard.build] purchase');
    // print(purchase);
    return Card(
      color: Theme.of(context).colorScheme.secondaryVariant,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) =>  PurchaseContentPage(
                user: user,
                purchase: purchase,
                dataSource: dataSource,
              ),
            )
          );
          // .pushNamed(context, '/second');
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              // color: PurchaseListSetting.cardBodyBgColor,
              // color: Theme.of(context).colorScheme.secondary, //PurchaseListSetting.cardTitleBgColor,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0,),
                child: Text(
                  '${purchase['preview']}',
                  style: Theme.of(context).textTheme.bodyText1
                ),
              ),
            ),
            // const SizedBox(height: 8,),
            Container(
              // color: Theme.of(context).colorScheme.secondary, //PurchaseListSetting.cardTitleBgColor,
              // color: PurchaseListSetting.cardBodyBgColor,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 4, right: 8.0,),
                child: Text(
                  '${purchase['description']}',
                  style: Theme.of(context).textTheme.bodyText1
                ),
              ),
            ),
            const SizedBox(height: 8,),
            Container(
              width: double.infinity,
              color: Theme.of(context).colorScheme.secondary, //PurchaseListSetting.cardTitleBgColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${purchase['name']}',
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    const SizedBox(height: 8,),
                    Text(
                      '${purchase['details']}',
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
    );
  }

  Future<bool?> _showDeleteDialog(BuildContext context) {
    return showDialog<bool>(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Удалить заметку?'),
          content: Text(
            purchase['name'].toString(),
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
