import 'package:flutter/material.dart';

class UserAccountPopupMenuBtn extends StatelessWidget {
  const UserAccountPopupMenuBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/filtered.png',
            width: 36.0,
            height: 36.0,
            color: Colors.primaries[9],
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
        
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/select-all.png',
                  width: 32.0,
                  height: 32.0,
                  color: Colors.primaries[9],
                ),
                const Text('Все'),
              ],
            ),
          ),
          PopupMenuItem(
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/ic_access_time.png',
                  width: 32.0,
                  height: 32.0,
                  color: Colors.primaries[9],
                ),
                const Text('Актуальные'),
              ],
            ),
          ),
          PopupMenuItem(
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/ic_history.png',
                  width: 32.0,
                  height: 32.0,
                  color: Colors.primaries[9],
                ),
                const Text('Архивные'),
              ],
            ),
          ),
        ];
      },
    );
  }
}
