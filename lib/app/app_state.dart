import 'package:flowers_app/app/app_events.dart';
import 'package:flowers_app/app/auth/auth_state.dart';
import 'package:flowers_app/app/purchase_overview/state.dart';

class AppState {
  final AppEvents appEvents;
  final AuthState authState;
  final PurchaseOverviewState purchaseOverviewState;
  AppState({
    required this.appEvents,
    required this.authState,
    required this.purchaseOverviewState,
  });
}