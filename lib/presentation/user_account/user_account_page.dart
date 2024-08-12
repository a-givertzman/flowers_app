import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/auth/app_user.dart';
import 'package:flowers_app/domain/notice/notice_list.dart';
import 'package:flowers_app/domain/notice/notice_list_viewed.dart';
import 'package:flowers_app/domain/order/order_list.dart';
import 'package:flowers_app/presentation/auth/change_password/change_password_page.dart';
import 'package:flowers_app/presentation/user_account/widgets/order_overview_body.dart';
import 'package:flowers_app/presentation/user_account/widgets/user_account_popup_menu_btn.dart';
import 'package:flutter/material.dart';
///
///
class UserAccountPage extends StatelessWidget {
  static const _debug = false;
  final AppUser _user;
  final NoticeListViewed _noticeListViewed;
  ///
  ///
  const UserAccountPage({
    super.key,
    required AppUser user,
    required NoticeListViewed noticeListViewed,
  }) : 
    _user = user,
    _noticeListViewed = noticeListViewed;
  //
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        // title: const Text(AppText.userAccount),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(_user.name),
                    Text('Баланс: ${_user.account}'),
                  ],
                ),
            ),
          ),
          const SizedBox(width: 2,),
          UserAccountPopupMenuBtn(
            onPaswordChangeSelected: (BuildContext context) {
              log(_debug, '[$UserAccountPage.UserAccountPopupMenuBtn.onPaswordChangeSelected] смена пароля');
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => ChangePasswordPage(
                    user: _user,
                  ),
                  settings: const RouteSettings(name: "/changePasswordPage"),
                ),
              )
              .then((result) {
                log(_debug, '[$UserAccountPage.UserAccountPopupMenuBtn.onPaswordChangeSelected] смена пароля завершена, результат: ', result);
              });
            },
            onLogoutSelected: (_) {
              Navigator.of(context).popUntil((route) {
                log(_debug, 'route:', route.settings.name); 
                return route.settings.name == '/signInPage';
              });
            },
          ),
          const SizedBox(width: 8,),
        ],
      ),
      body: OrderOverviewBody(
        user: _user,
        orderList: OrderList(),
        noticeList: NoticeList(noticeListViewed: _noticeListViewed), 
        noticeListViewed: _noticeListViewed,
      ),
    );
  }
}
