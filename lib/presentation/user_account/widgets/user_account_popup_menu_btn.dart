import 'package:flowers_app/assets/texts/app_text.dart';
import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/presentation/core/widgets/icons.dart';
import 'package:flutter/material.dart';

class UserAccountPopupMenuBtn extends StatelessWidget {
  final void Function(BuildContext context)? _onPaswordChangeSelected; 
  const UserAccountPopupMenuBtn({
    Key? key,
    void Function(BuildContext context)? onPaswordChangeSelected,
  }) : 
    _onPaswordChangeSelected = onPaswordChangeSelected,
    super(key: key);
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          appIcons.accountCircle,
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
          /// Смена пароля
          PopupMenuItem(
            onTap: () {
              final _callBack = _onPaswordChangeSelected;
              if (_callBack != null) {
                _callBack(context);
                log('[$UserAccountPopupMenuBtn.PopupMenuItem.onTap] смена пароля');
              }
            },
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/lock_settings.png',
                  width: 32.0,
                  height: 32.0,
                  color: Colors.primaries[9],
                ),
                const SizedBox(width: 8.0,),
                const Text(AppText.changePassword),
              ],
            ),
          ),
          /// переход в диалог настроек
          // PopupMenuItem(
          //   child: Row(
          //     children: [
          //       Image.asset(
          //         'assets/icons/ic_access_time.png',
          //         width: 32.0,
          //         height: 32.0,
          //         color: Colors.primaries[9],
          //       ),
          //       const Text(AppText.settingsPage),
          //     ],
          //   ),
          //   onTap: () {
          //   },
          // ),
          /// выход из профиля пользователя
          PopupMenuItem(
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/logout.png',
                  width: 32.0,
                  height: 32.0,
                  color: Colors.primaries[9],
                ),
                const SizedBox(width: 8.0,),
                const Text(AppText.userLogout),
              ],
            ),
            onTap: () {
              Navigator.of(context).popUntil((route) {
                log('route:', route.settings.name); 
                return route.settings.name == '/signInPage';
              });
              // ModalRoute.withName('/signInPage'));
            },
          ),
        ];
      },
    );
  }
}
