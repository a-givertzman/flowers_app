import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/auth/user_group.dart';
import 'package:flowers_app/domain/purchase/purchase_status.dart';
import 'package:flowers_app/presentation/purchase/purchase_overview/purchase_overview_page.dart';
import 'package:flutter/material.dart';

class ViewFilterPopupMenuBtn extends StatefulWidget {
  final ViewFilter initialValue;
  final Color color;
  final void Function(ViewFilter) onSelected;
  final UserGroup _userGroup;
  const ViewFilterPopupMenuBtn({
    Key? key,
    required this.initialValue,
    required this.color,
    required this.onSelected,
    required UserGroup userGroup,
  }) : 
    _userGroup = userGroup,
    super(key: key);
  UserGroup get userGroup => _userGroup;
  @override
  State<ViewFilterPopupMenuBtn> createState() => _ViewFilterPopupMenuBtnState();
}

class _ViewFilterPopupMenuBtnState extends State<ViewFilterPopupMenuBtn> {
  static const _debug = false;
  late ViewFilter _viewFilterValue;
  late UserGroup _userGroup;
  @override
  void initState() {
    _viewFilterValue = widget.initialValue;
    _userGroup = widget.userGroup;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ViewFilter>(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/filter_list.png',
            width: 32.0,
            height: 32.0,
            color: widget.color,
          ),
        ],
      ),
      onSelected: (value) {
        log(_debug, '[_ViewFilterPopupMenuBtnState.build] selected filter: ', value);
        widget.onSelected(value);
        setState(() {
          _viewFilterValue = value;
        });
      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<ViewFilter>>[
          PopupMenuItem(
            key: const ValueKey(ViewFilter.all),
            value: ViewFilter.all,
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/done_all.png',
                  width: 32.0,
                  height: 32.0,
                  color: _viewFilterValue == ViewFilter.all ? Colors.primaries[9] : null,
                ),
                const SizedBox(width: 8.0,),
                const Text('Все'),
              ],
            ),
          ),
          if ([UserGroupList.admin, UserGroupList.manager].contains(_userGroup.value)) 
            PopupMenuItem(
              key: const ValueKey(ViewFilter.prepare),
              value: ViewFilter.prepare,
              child: Row(
                children: [
                  Image.asset(
                    'assets/icons/settings.png',
                    width: 32.0,
                    height: 32.0,
                    color: _viewFilterValue == ViewFilter.prepare ? Colors.primaries[9] : null,
                  ),
                  const SizedBox(width: 8.0,),
                  Text(PurchaseStatus(status: PurchaseStatusList.prepare).text()),
                ],
              ),
            ),
          PopupMenuItem(
            key: const ValueKey(ViewFilter.active),
            value: ViewFilter.active,
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/shopping-cart.png',
                  width: 32.0,
                  height: 32.0,
                  color: _viewFilterValue == ViewFilter.active ? Colors.primaries[9] : null,
                ),
                const SizedBox(width: 8.0,),
                const Text('Актуальные'),
              ],
            ),
          ),
          if ([UserGroupList.admin, UserGroupList.manager].contains(_userGroup.value)) 
            PopupMenuItem(
              key: const ValueKey(ViewFilter.purchase),
              value: ViewFilter.purchase,
              child: Row(
                children: [
                  Image.asset(
                    'assets/icons/shopping-cart.png',
                    width: 32.0,
                    height: 32.0,
                    color: _viewFilterValue == ViewFilter.purchase ? Colors.primaries[9] : null,
                  ),
                  const SizedBox(width: 8.0,),
                  Text(PurchaseStatus(status: PurchaseStatusList.purchase).text()),
                ],
              ),
            ),
          if ([UserGroupList.admin, UserGroupList.manager].contains(_userGroup.value)) 
            PopupMenuItem(
              key: const ValueKey(ViewFilter.distribute),
              value: ViewFilter.distribute,
              child: Row(
                children: [
                  Image.asset(
                    'assets/icons/truck.png',
                    width: 32.0,
                    height: 32.0,
                    color: _viewFilterValue == ViewFilter.distribute ? Colors.primaries[9] : null,
                  ),
                  const SizedBox(width: 8.0,),
                  Text(PurchaseStatus(status: PurchaseStatusList.distribute).text()),
                ],
              ),
            ),
          PopupMenuItem(
            key: const ValueKey(ViewFilter.archived),
            value: ViewFilter.archived,
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/storage.png',
                  width: 32.0,
                  height: 32.0,
                  color: _viewFilterValue == ViewFilter.archived ? Colors.primaries[9] : null,
                ),
                const SizedBox(width: 8.0,),
                const Text('Архивные'),
              ],
            ),
          ),
          if ([UserGroupList.admin, UserGroupList.manager].contains(_userGroup.value)) 
            PopupMenuItem(
              key: const ValueKey(ViewFilter.canceled),
              value: ViewFilter.canceled,
              child: Row(
                children: [
                  Image.asset(
                    'assets/icons/remove_shopping_cart.png',
                    width: 32.0,
                    height: 32.0,
                    color: _viewFilterValue == ViewFilter.canceled ? Colors.primaries[9] : null,
                  ),
                  const SizedBox(width: 8.0,),
                  Text(PurchaseStatus(status: PurchaseStatusList.canceled).text()),
                ],
              ),
            ),
        ];
      },
    );
  }
}
