import 'package:flowers_app/domain/purchase/purchase_content.dart';
import 'package:flowers_app/domain/purchase/purchase_list.dart';
import 'package:flowers_app/infrastructure/api/api_params.dart';
import 'package:flowers_app/infrastructure/datasource/data_source.dart';
import 'package:flowers_app/presentation/purchase/purchase_content/widgets/purchase_content_body.dart';
import 'package:flowers_app/presentation/purchase/purchase_overview/widgets/purchase_overview_body.dart';
import 'package:flutter/material.dart';

class PurchaseContentPage extends StatelessWidget {
  final String id;
  final DataSource dataSource;
  const PurchaseContentPage({
    Key? key,
    required this.id,
    required this.dataSource,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              // backgroundColor: PurchaseListSetting.appBarTitleBgColor,
              title: const Text('Закупки'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: const <Widget>[
                // UncompletedSwitch(),
              ],
              automaticallyImplyLeading: false,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                //TODO FloatingActionButton action to be implemented
                throw Exception('FloatingActionButton action to be implemented');
                // AutoRouter.of(context).push(NoteFormPageRoute(note: null));
              },
              child: const Icon(Icons.add),
            ),
            body: Center(
                  child: PurchaseContentBody(
                    purchaseContent: PurchaseContent(
                      id: id,
                      remote: dataSource.dataSet('purchase_content')
                        .withParams(
                          ApiParams(
                            where: [{'operator': 'where', 'field': 'purchase/id', 'cond': '=', 'value': id}]
                          )
                        ),
                    ), 
                  ),
                ),
    );
  }
}
