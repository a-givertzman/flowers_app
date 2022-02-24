import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/presentation/purchase/purchase_overview/purchase_overview_page.dart';
import 'package:flutter/material.dart';

class ViewFilterPopupMenuBtn extends StatefulWidget {
  final ViewFilter initialValue;
  final Color color;
  final void Function(ViewFilter) onSelected;
  const ViewFilterPopupMenuBtn({
    Key? key,
    required this.initialValue,
    required this.color,
    required this.onSelected,
  }) : super(key: key);

  @override
  State<ViewFilterPopupMenuBtn> createState() => _ViewFilterPopupMenuBtnState();
}

class _ViewFilterPopupMenuBtnState extends State<ViewFilterPopupMenuBtn> {
  static const _debug = false;
  late ViewFilter _viewFilterValue;
  @override
  void initState() {
    _viewFilterValue = widget.initialValue;
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
        return [
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
          PopupMenuItem(
            key: const ValueKey(ViewFilter.actual),
            value: ViewFilter.actual,
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/shopping-cart.png',
                  width: 32.0,
                  height: 32.0,
                  color: _viewFilterValue == ViewFilter.actual ? Colors.primaries[9] : null,
                ),
                const SizedBox(width: 8.0,),
                const Text('Актуальные'),
              ],
            ),
          ),
          PopupMenuItem(
            key: const ValueKey(ViewFilter.archived),
            value: ViewFilter.archived,
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/lock_outline.png',
                  width: 32.0,
                  height: 32.0,
                  color: _viewFilterValue == ViewFilter.archived ? Colors.primaries[9] : null,
                ),
                const SizedBox(width: 8.0,),
                const Text('Архивные'),
              ],
            ),
          ),
        ];
      },
    );
  }
}
