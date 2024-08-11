import 'package:another_flushbar/flushbar_helper.dart';
import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_app/assets/settings/common_settings.dart';
import 'package:flowers_app/assets/texts/app_text.dart';
import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/auth/app_user.dart';
import 'package:flowers_app/domain/auth/auth_result.dart';
import 'package:flowers_app/domain/auth/authenticate.dart';
import 'package:flowers_app/domain/auth/user_phone.dart';
import 'package:flowers_app/presentation/auth/register_user/register_user_page.dart';
import 'package:flowers_app/presentation/auth/sign_in/user_pass_page.dart';
import 'package:flowers_app/presentation/auth/sign_in/widgets/phone_number_widget.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flowers_app/presentation/core/widgets/in_pogress_overlay.dart';
import 'package:flowers_app/presentation/purchase/purchase_overview/purchase_overview_page.dart';
import 'package:flowers_app/settings/setting.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_result_new.dart';

class SignInForm extends StatefulWidget {
  final Authenticate auth;
  const SignInForm({
    super.key,
    required this.auth,
  });
  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  static const _debug = true;
  bool _isLoading = true;
  late UserPhone _userPhone;
  // late UserPassword _userPassword;
  _SignInFormState() {
    _userPhone = UserPhone(
      phone: '', 
    );
  }
  @override
  void initState() {
    _isLoading = true;
    widget.auth
      .authenticateIfStored()
      .then((authResult) {
        if (authResult.authenticated()) {
          _setAuthState(authResult, true);
        }
        setState(() {
           _isLoading = false;
        });
      });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      log(_debug, '[_SignInFormState.build] _isLoading!!!');
      return const InProgressOverlay(
        isSaving: true,
        message: AppText.loading,
      );
    } else {
      return _buildSignInWidget(context);
    }
  }
  Widget _buildSignInWidget(BuildContext context) {
    log(_debug, '[_SignInFormState._buildSignInWidget]');
    const paddingValue = 13.0;
    return Form(
      autovalidateMode: AutovalidateMode.always,
      child: ListView(
        padding: const EdgeInsets.all(paddingValue * 2),
        children: [
          Text(
            AppText.jointPurchases,
            style: appThemeData.textTheme. displayMedium,
          ),
          Text(
            AppText.welcome,
            style: appThemeData.textTheme.titleSmall,
          ),
          const SizedBox(height: paddingValue * 6),
          Text(
            AppText.pleaseAuthenticateToContinue,
            style: appThemeData.textTheme.bodyMedium,
          ),
          const SizedBox(height: paddingValue),
          PhoneNumbetWidget(
            userPhone: _userPhone,
            onCompleted: (userPhone) {
              _userPhone = userPhone;
              _tryFindUser(userPhone);
              // _showOtpPage(userPhone);
              // _showUserIdPage(userPhone);
            },
          ),
        ],
      ),
    );
  }
  /// ищем пользователя в базе по номеру телефона
  void _tryFindUser(UserPhone userPhone) {
    setState(() {
      _isLoading = true;
    });
    widget.auth.logout();
    widget.auth.getUser()
      .fetch(userPhone)
      .then((result) {
        log(_debug, '._tryFindUser | result: ', result);
        setState(() {
          _isLoading = false;
        });
        switch (result) {
          case Ok(value: final user):
            log(_debug, '._tryFindUser | user: ', user);
            log(_debug, '._tryFindUser | user.exists: ', user.exists);
            if (user.exists) {
              // вход после проверки по смс-коду или паролю
              _showUserIdPage(_userPhone, user);
            } else {
              // регистрация нового пользователя
              _tryRegister(_userPhone);
            }
          case Err(error: final _):
            _tryRegister(_userPhone);
        }
      });
  }
  void _showUserIdPage(UserPhone userPhone, AppUser user) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UserPassPage(
          user: user,
          userPhone: userPhone,
        ),
        settings: const RouteSettings(name: "/userPassPage"),
      ),
    ).then((userExists) {
      log(_debug, '[_SignInFormState._showUserIdPage] userExists: $userExists');
      if (userExists is bool && userExists) {
        _tryAuth(_userPhone.number, userExists);
      } else {
        log(_debug, '[_showUserIdPage] пользователь не прошел проверку');
        setState(() {
          _userPhone = userPhone;
          _isLoading = false;
        });
      }
    });    
  }
  // void _showOtpPage(UserPhone userPhone) {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) => OtpCodePage(
  //         userPhone: userPhone,
  //         timeout: AppUiSettings.smsResendTimeout,
  //       ),
  //       settings: const RouteSettings(name: "/otpCodePage"),
  //     ),
  //   ).then((isVerified) {
  //     log(_debug, '[_SignInFormState._showOtpPage] completed with: $isVerified');
  //     if (isVerified == null) {
  //       setState(() {_isLoading = false;});
  //     } else {
  //       if (isVerified as bool) {
  //         _tryAuth(_userPhone.value(), isVerified);
  //       } else {
  //         setState(() {_isLoading = false;});
  //       }
  //     }
  //   });    
  // }
  void _tryRegister(UserPhone userPhone) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>  RegisterUserPage(
          userPhone: userPhone,
        ),
        settings: const RouteSettings(name: "/registerUserPage"),
      ),
    ).then((isRegistered) {
      if (isRegistered is bool && isRegistered) {
        _tryAuth(userPhone.number, true);
      }
    });
  }
  void _tryAuth(String userPhone, bool userPhoneVerified) {
    setState(() {_isLoading = true;});
    widget
      .auth
      .authenticateByPhoneNumber(userPhone)
      .then((authResult) {
        _setAuthState(authResult, userPhoneVerified);
      });
  }
  Future<void> _setAuthState(AuthResult authResult, bool userPhoneVerified) async {
    if (authResult.authenticated()) {
      log(_debug, '[_SignInFormState._setAuthState] Authenticated!!!');
      setState(() {_isLoading = false;});
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>  PurchaseOverviewPage(
            remote: SqlAccess(
              address: ApiAddress(host: const Setting('api-host').toString(), port: const Setting('api-port').toInt),
              authToken: const Setting('api-auth-token').toString(),
              database: const Setting('api-database').toString(),
              sqlBuilder: (sql, id) {
                return Sql(sql: "select * from purchase;");
              },
              entryBuilder: (row) => row,
            ),
            user: authResult.user(),
          ),
          settings: const RouteSettings(name: "/purchaseOverviewPage"),
        ),
      ).then((_) {
        setState(() {_isLoading = true;});
        widget.auth.logout().then((authResult) {
          setState(() {_isLoading = false;});
        });
      });
    } else {
      log(_debug, '[_SignInFormState._setAuthState] Not Authenticated!!!');
      setState(() {_isLoading = false;});
      if (userPhoneVerified) {
        if (!mounted) return;
        _tryRegister(_userPhone);
      }
      if (authResult.message() != '') {
        _showFlushBar(context, authResult.message());
      }
    }
  }
  void _showFlushBar(BuildContext context, String message) {
    FlushbarHelper.createError(
      duration: AppUiSettings.flushBarDuration,
      message: message,
    ).show(context);
  }
}
