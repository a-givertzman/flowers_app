import 'package:flowers_app/presentation/purchase/purchase_overview/purchase_overview_page.dart';
import 'package:flutter/material.dart';

class UserAccountPopupMenuBtn extends StatefulWidget {
  final viewFilter initialValue;
  final Color color;
  final void Function(viewFilter) onSelected;
  const UserAccountPopupMenuBtn({
    Key? key,
    required this.initialValue,
    required this.color,
    required this.onSelected,
  }) : super(key: key);

  @override
  State<UserAccountPopupMenuBtn> createState() => _UserAccountPopupMenuBtnState();
}

class _UserAccountPopupMenuBtnState extends State<UserAccountPopupMenuBtn> {
  late viewFilter viewFilterValue;
  @override
  void initState() {
    viewFilterValue = widget.initialValue;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<viewFilter>(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/filter_list.png',
            width: 32.0,
            height: 32.0,
            color: widget.color,
          ),
          // const Text('Фильтр',
          //   style: TextStyle(
          //     height: 1.3,
          //     fontSize: 10.5,
          //   ),
          // ),
        ],
      ),
      onSelected: (value) {
        widget.onSelected(value);
        setState(() {
          viewFilterValue = value;
        });
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            value: viewFilter.all,
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/done_all.png',
                  width: 32.0,
                  height: 32.0,
                  color: viewFilterValue == viewFilter.all ? Colors.primaries[9] : null,
                ),
                const SizedBox(width: 8.0,),
                const Text('Все'),
              ],
            ),
          ),
          PopupMenuItem(
            value: viewFilter.actual,
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/shopping-cart.png',
                  width: 32.0,
                  height: 32.0,
                  color: viewFilterValue == viewFilter.actual ? Colors.primaries[9] : null,
                ),
                const SizedBox(width: 8.0,),
                const Text('Актуальные'),
              ],
            ),
          ),
          PopupMenuItem(
            value: viewFilter.archived,
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/lock_outline.png',
                  width: 32.0,
                  height: 32.0,
                  color: viewFilterValue == viewFilter.archived ? Colors.primaries[9] : null,
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
