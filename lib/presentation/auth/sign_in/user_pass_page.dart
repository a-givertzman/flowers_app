import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flowers_app/assets/settings/common_settings.dart';
import 'package:flowers_app/assets/texts/app_text.dart';
import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/auth/app_user.dart';
import 'package:flowers_app/domain/auth/user_password.dart';
import 'package:flowers_app/domain/auth/user_phone.dart';
import 'package:flowers_app/domain/core/timers/count_timer.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flutter/material.dart';

/// Класс проверяет пользователя по ID
/// Все участники закупок знают свой ID
/// И в данном случае этот ID выступает в роли пароля
class UserPassPage extends StatefulWidget {
  final AppUser _user;
  final UserPhone _userPhone;
  const UserPassPage({
    Key? key,
    required AppUser user,
    required UserPhone userPhone,
  }) :
    _user = user,
    _userPhone = userPhone,
    super(key: key);
  AppUser user() => _user;
  UserPhone userPhone() => _userPhone;
  @override
  _UserPassPageState createState() => _UserPassPageState();
}

class _UserPassPageState extends State<UserPassPage> {
  static const _debug = false;
  bool _isLoading = false;
  bool _allowResend = true;
  int _secondsLeft = 0;
  int _resendTimeout = 1;
  double _resendTimeoutRaw = 1;
  late UserPassword _userPass;
  late CountTimer _countTimer;
  @override
  void initState() {
    _isLoading = false;
    _userPass = UserPassword(value: '');
    _countTimer = CountTimer(
      count: _resendTimeout,
      onTick:(int secondsLeft) {
        if (mounted) {
          setState(() {
            _secondsLeft = secondsLeft;
          });
        }
      },
      onComplete: () {
        _onResendAllowed();
      },
    );
    super.initState();
  }
  @override
  void dispose() {
    _countTimer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    const paddingValue = 13.0;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(AppText.yourPassword),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(paddingValue * 2),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const SizedBox(height: paddingValue * 2),
            Text(
              'Ваш номер телефона:',
              style: appThemeData.textTheme.bodyText2,
            ),
            const SizedBox(height: paddingValue),
            SizedBox(
              width: double.infinity,
              child: Text(
                widget._userPhone.numberWithCode(),
                style: appThemeData.textTheme.subtitle2,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: paddingValue * 4),
            Text(
              AppText.pleaseEnterYourPassword,
              style: appThemeData.textTheme.bodyText2,
            ),
            const SizedBox(height: paddingValue),
              TextFormField(
                style: appThemeData.textTheme.bodyText2,
                maxLength: _userPass.maxLength,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.lock,
                    // color: appThemeData.colorScheme.onPrimary,
                  ),
                  errorStyle: TextStyle(
                    height: 1.1,
                  ),
                  errorMaxLines: 5,
                ),
                autocorrect: false,
                onChanged: (value) {
                  setState(() {
                    _userPass = UserPassword(value: value);
                  });
                },
              ),
              const SizedBox(height: paddingValue),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _allowResend
                    ? _verifyUserPass
                    : null,
                  child: _allowResend
                    ? const Text(AppText.next)
                    : Text('${AppText.next} ($_secondsLeft)'),
                ),
              ),
              const SizedBox(height: paddingValue),
              if(_isLoading) ...[
                const SizedBox(height: paddingValue,),
                const LinearProgressIndicator(),
              ],
            ],
          ),
        ),
      ),
    );
  }
  void _verifyUserPass() {
    setState(() {
      _isLoading = true;
    });
    final user = widget.user();
    final userPass = user['pass'].toString();
    log(_debug, '[_verifyUserId] user:', user);
    log(_debug, '[_verifyUserId] _enteredUserId:', _userPass.encrypted());
    if (userPass == _userPass.encrypted()) {
      _updateResendTimeout(reset: true);
      Navigator.of(context).pop(true);
    } else {
      _updateResendTimeout();
      FlushbarHelper.createError(
        duration: AppUiSettings.flushBarDuration,
        message: AppText.wrongPass,
      ).show(context);
    }
    setState(() {
      _isLoading = false;
    });
  }
  void _updateResendTimeout({bool? reset}) {
    _countTimer.cancel();
    if (reset is bool && reset) {
      _resendTimeoutRaw = 1;
    } else {
      _resendTimeoutRaw = _resendTimeoutRaw > 120
        ? 1
        : _resendTimeoutRaw * _resendTimeoutRaw * 1.14;
    }
    _resendTimeout = _resendTimeoutRaw.round();
    log(_debug, '[_updateResendTimeout] _resendTimeout:', _resendTimeout);
    _countTimer.run(count: _resendTimeout);
    setState(() {
      _allowResend = _resendTimeout <= 1;
      _secondsLeft = _resendTimeout;
    });
  }
  void _onResendAllowed() {
    setState(() {
      _allowResend = true;
    });
  }
}
