import 'package:flowers_app/domain/purchase/purchase_list.dart';
import 'package:flowers_app/infrastructure/datasource/data_source.dart';
import 'package:flowers_app/presentation/purchase/purchase_overview/widgets/purchase_overview_body.dart';
import 'package:flutter/material.dart';

class PurchaseOverviewPage extends StatelessWidget {
  final DataSource dataSource;
  const PurchaseOverviewPage({
    Key? key,
    required this.dataSource,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              // backgroundColor: PurchaseListSetting.appBarTitleBgColor,
              title: const Text('Закупки'),
              leading: IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  //TODO AppBar leading Button action to be implemented
                  throw Exception('AppBar leading Button action to be implemented');
                  // context.read<AuthBloc>().add(
                  //   const AuthEvent.signedOut(),
                  // );
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
                  child: PurchaseOverviewBody(
                    purchaseList: PurchaseList(
                      dataSetName: 'purchase',
                      dataSource: dataSource,
                    ), 
                  ),
                ),
    );
  }
}
