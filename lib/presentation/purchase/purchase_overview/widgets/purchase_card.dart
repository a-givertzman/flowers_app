import 'package:flowers_app/domain/purchase/purchase.dart';
import 'package:flowers_app/domain/user/user.dart';
import 'package:flowers_app/infrastructure/datasource/app_data_source.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
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
      color: appThemeData.colorScheme.secondaryVariant,
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
              // color: appThemeData.colorScheme.secondary, //PurchaseListSetting.cardTitleBgColor,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0,),
                child: Text(
                  '${purchase['preview']}',
                  style: appThemeData.textTheme.bodyText2
                ),
              ),
            ),
            // const SizedBox(height: 8,),
            Container(
              // color: appThemeData.colorScheme.secondary, //PurchaseListSetting.cardTitleBgColor,
              // color: PurchaseListSetting.cardBodyBgColor,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 4, right: 8.0,),
                child: Text(
                  '${purchase['description']}',
                  style: appThemeData.textTheme.bodyText2
                ),
              ),
            ),
            const SizedBox(height: 8,),
            Container(
              width: double.infinity,
              color: appThemeData.colorScheme.secondary, //PurchaseListSetting.cardTitleBgColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${purchase['name']}',
                      textAlign: TextAlign.left,
                      style: appThemeData.textTheme.subtitle2,
                    ),
                    const SizedBox(height: 8,),
                    Text(
                      '${purchase['details']}',
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
    );
  }
}
