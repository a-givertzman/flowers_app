import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flowers_app/assets/settings/common_settings.dart';
import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/auth/auth_result.dart';
import 'package:flowers_app/domain/auth/authenticate.dart';
import 'package:flowers_app/domain/auth/user_phone.dart';
import 'package:flowers_app/infrastructure/datasource/app_data_source.dart';
import 'package:flowers_app/presentation/auth/register_user/register_user_page.dart';
import 'package:flowers_app/presentation/auth/sign_in/otp_code_page.dart';
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
  // bool _first = true;
  bool _isLoading = false;
  late UserPhone _userPhone;
  _SignInFormState() {
    _userPhone = UserPhone(
      phone: '', 
    );
  }
  @override
  void initState() {
    widget.auth
      .authenticateIfStored()
      .then((authResult) {
        if (authResult.authenticated()) {
          _setAuthState(authResult, true);
        }
        _isLoading = false;
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
            message: AppMessages.loadingMessage,
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
            'Совместные закупки',
            style: appThemeData.textTheme.headline2,
          ),
          Text(
            'Добро пожаловать!',
            style: appThemeData.textTheme.subtitle2,
          ),
          const SizedBox(height: paddingValue * 6),
          Text(
            'Авторизуйтесь что бы продолжить...',
            style: appThemeData.textTheme.bodyText2,
          ),
          const SizedBox(height: paddingValue),
          PhoneNumbetWidget(
            onCompleted: (userPhone) {
              setState(() {
                _isLoading = true;
                _userPhone = userPhone;
              });
              _showOtpDialog(_userPhone);
            },
          ),
        ],
      ),
    );
  }
  void _showOtpDialog(UserPhone userPhone) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtpCodePage(
          userPhone: userPhone,
          timeout: AppUiSettings.smsResendTimeout,
        ),
      ),
    ).then((isVerified) {
      log('[_SignInFormState._showOtpDialog] completed with: $isVerified');
      if (isVerified == null) {
        setState(() {_isLoading = false;});
      } else {
        if (isVerified as bool) {
          _tryAuth(_userPhone.value(), isVerified);
        } else {
          setState(() {_isLoading = false;});
        }
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
      if (authResult.message() != '') {
        FlushbarHelper.createError(
          duration: AppUiSettings.flushBarDuration,
          message: authResult.message(),
        ).show(context);
        await Future.delayed(AppUiSettings.flushBarDuration);
      }
      if (userPhoneVerified) {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  RegisterUserPage(
              userPhone: _userPhone,
            ),
          ),
        ).then((isRegistered) {
          if (isRegistered as bool) {
            _tryAuth(_userPhone.value(), true);
          }
        });
      }
    }
  }
}
