import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flowers_app/assets/settings/common_settings.dart';
import 'package:flowers_app/assets/texts/app_text.dart';
import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/auth/app_user.dart';
import 'package:flowers_app/domain/auth/auth_result.dart';
import 'package:flowers_app/domain/auth/authenticate.dart';
import 'package:flowers_app/domain/auth/user_phone.dart';
import 'package:flowers_app/infrastructure/datasource/app_data_source.dart';
import 'package:flowers_app/presentation/auth/register_user/register_user_page.dart';
import 'package:flowers_app/presentation/auth/sign_in/user_pass_page.dart';
import 'package:flowers_app/presentation/auth/sign_in/widgets/phone_number_widget.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flowers_app/presentation/core/widgets/in_pogress_overlay.dart';
import 'package:flowers_app/presentation/purchase/purchase_overview/purchase_overview_page.dart';
import 'package:flutter/material.dart';

class SignInForm extends StatefulWidget {
  final Authenticate auth;
  const SignInForm({
    Key? key,
    required this.auth,
  }) : super(key: key);
  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
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
    return StreamBuilder(
      // stream: user.authStream,
      builder: (context, auth) {
        if (_isLoading) {
          log('[_SignInFormState.build] _isLoading!!!');
          return const InProgressOverlay(
            isSaving: true,
            message: AppText.loading,
          );
        } else {
          return _buildSignInWidget(context, auth);
        }
      },
    );
  }
  Widget _buildSignInWidget(BuildContext context, AsyncSnapshot<Object?> auth) {
    log('[_SignInFormState._buildSignInWidget]');
    const paddingValue = 13.0;
    return Form(
      autovalidateMode: AutovalidateMode.always,
      child: ListView(
        padding: const EdgeInsets.all(paddingValue * 2),
        children: [
          Text(
            AppText.jointPurchases,
            style: appThemeData.textTheme.headline2,
          ),
          Text(
            AppText.welcome,
            style: appThemeData.textTheme.subtitle2,
          ),
          const SizedBox(height: paddingValue * 6),
          Text(
            AppText.pleaseAuthenticateToContinue,
            style: appThemeData.textTheme.bodyText2,
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
      .fetch(params: {
        'phoneNumber': userPhone.number(),
      },)
      .then((user) {
        log('[_tryFindUser] user: ', user);
        setState(() {
          _isLoading = false;
        });
        if (user.exists()) {
          // вход после проверки по смс-коду или паролю
          _showUserIdPage(_userPhone, user);
        } else {
          // регистрация нового пользователя
          _tryRegister(_userPhone);
        }
      });
  }
  void _showUserIdPage(UserPhone userPhone, AppUser user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserPassPage(
          user: user,
          userPhone: userPhone,
        ),
      ),
    ).then((userExists) {
      log('[_SignInFormState._showUserIdPage] userExists: $userExists');
      if (userExists is bool && userExists) {
        _tryAuth(_userPhone.number(), userExists);
      } else {
        log('[_showUserIdPage] пользователь не прошел проверку');
        setState(() {
          _userPhone = userPhone;
          _isLoading = false;
        });
      }
    });    
  }
  // void _showOtpPage(UserPhone userPhone) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => OtpCodePage(
  //         userPhone: userPhone,
  //         timeout: AppUiSettings.smsResendTimeout,
  //       ),
  //     ),
  //   ).then((isVerified) {
  //     log('[_SignInFormState._showOtpPage] completed with: $isVerified');
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>  RegisterUserPage(
          userPhone: userPhone,
        ),
      ),
    ).then((isRegistered) {
      if (isRegistered is bool && isRegistered) {
        _tryAuth(userPhone.number(), true);
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
      log('[_SignInFormState._setAuthState] Authenticated!!!');
      setState(() {_isLoading = false;});
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>  PurchaseOverviewPage(
            dataSource: dataSource,
            user: authResult.user(),
          ),
        ),
      ).then((_) {
        setState(() {_isLoading = true;});
        widget.auth.logout().then((authResult) {
          setState(() {_isLoading = false;});
        });
      });
    } else {
      log('[_SignInFormState._setAuthState] Not Authenticated!!!');
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
