import 'package:flowers_app/app/purchase_overview/events.dart';
import 'package:flowers_app/domain/purchase/purchase.dart';
import 'package:flowers_app/domain/purchase/purchase_list.dart';
import 'package:flowers_app/infrastructure/api/api_request.dart';
import 'package:flowers_app/infrastructure/api/api_params.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';
import 'package:flowers_app/infrastructure/datasource/data_source.dart';

class PurchaseOverviewState {
  final PurchaseOverviewEvent purchaseOverviewEvents;
  PurchaseOverviewState({
    required this.purchaseOverviewEvents,
  });

  Stream<List<Purchase>> nandleEvents(
    PurchaseOverviewEvent event
  ) async* {
  }
}