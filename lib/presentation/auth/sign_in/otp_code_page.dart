import 'package:another_flushbar/flushbar_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flowers_app/assets/settings/common_settings.dart';
import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/auth/user_phone.dart';
import 'package:flowers_app/domain/auth/user_phone_verify.dart';
import 'package:flowers_app/domain/core/timers/count_timer.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flutter/material.dart';

class OtpCodePage extends StatefulWidget {
  final int _resendTimeout;
  final UserPhone _userPhone;
  const OtpCodePage({
    Key? key,
    required UserPhone userPhone,
    required int timeout,
  }) :
    _userPhone = userPhone,
    _resendTimeout = timeout,
    super(key: key);
  UserPhone userPhone() => _userPhone;
  @override
  _OtpCodePageState createState() => _OtpCodePageState();
}

class _OtpCodePageState extends State<OtpCodePage> {
  bool _isLoading = true;
  String _enteredOtp = '';
  bool _allowResend = false;
  int _secondsLeft = 0;
  late CountTimer _countTimer;
  late UserPhoneVerify _userPhoneVerify;
  @override
  void initState() {
    _isLoading = true;
    _countTimer = CountTimer(
      count: widget._resendTimeout,
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
    _userPhoneVerify = UserPhoneVerify(
      phone: widget.userPhone().value(), 
      timeout: widget._resendTimeout,
      onCodeSent: _onCodeSent, 
      onCodeAutoRetrievalTimeout: _onCodeAutoRetrievalTimeout, 
      onVerificationCompleted: _onVerificationCompleted, 
      onVerificationFailed: _onVerificationFailed,
    );
    _userPhoneVerify.verifyPhone();
    _secondsLeft = widget._resendTimeout;
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
        title: const Text('смс-код'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(paddingValue * 2),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const SizedBox(height: paddingValue * 6),
            Text(
              'Введите 6-ти значный код из смс',
              style: appThemeData.textTheme.bodyText2,
            ),
            const SizedBox(height: paddingValue),
              TextFormField(
                style: appThemeData.textTheme.bodyText2,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.lock,
                    color: appThemeData.colorScheme.onPrimary,
                  ),
                  labelText: 'смс - код',
                  labelStyle: appThemeData.textTheme.bodyText2,
                  errorStyle: const TextStyle(
                    height: 1.1,
                  ),
                  errorMaxLines: 5,
                ),
                autocorrect: false,
                onChanged: (value) {
                  setState(() {
                    _enteredOtp = value;
                  });
                },
              ),
              const SizedBox(height: paddingValue),
              ElevatedButton(
                onPressed: _enteredOtp.length >= 4 && _enteredOtp.length <= 7
                  ? _verifyOtp
                  : null,
                child: const Text('Ok'),
              ),
              const SizedBox(height: paddingValue),
              ElevatedButton(
                onPressed: _allowResend
                  ? () {
                    setState(() {
                      _isLoading = true;
                      _allowResend = false;
                    });
                    _userPhoneVerify.verifyPhone();
                    _secondsLeft = widget._resendTimeout;
                  }
                  : null,
                child: _allowResend 
                  ? const Text('Отправить код')
                  : Text('Отправить код ($_secondsLeft)'),
              ),
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
  void _verifyOtp() {
    setState(() {
      _isLoading = true;
    });
    _userPhoneVerify.verifyOtp(_enteredOtp)
      .then((verified) {
        if (verified) {
          Navigator.pop(context, verified);
        } else {
          FlushbarHelper.createError(
            duration: AppUiSettings.flushBarDuration,
            message: 'Неверный код',
          ).show(context);
        }
      });
  }
  void _onCodeSent(String str, int? id) {
    setState(() {
      _isLoading = false;
    });
    _countTimer.cancel();
    _countTimer.run();
    log('[_OtpCodeWidgetState._onCodeSent] Код отправлен');
    log('   str: $str');
    log('   id: $id');
  }
  void _onResendAllowed() {
    setState(() {
      _allowResend = true;
    });
  }

  void _onCodeAutoRetrievalTimeout(String verId) {
    setState(() {
      _isLoading = false;
    });
  }

  void _onVerificationCompleted(PhoneAuthCredential phoneAuthCredential) {
    setState(() {
      _isLoading = false;
    });
    log('[_OtpCodeWidgetState._onVerificationCompleted] phoneAuthCredential: $phoneAuthCredential');
  }

  void _onVerificationFailed(FirebaseAuthException exception) {
    FlushbarHelper.createError(
      duration: const Duration(seconds: 10),
      message: 'Проверьте номер телефона или попробуте еще раз познее,\nОшибка: ${exception.message}',
    ).show(context);
    setState(() {
      _isLoading = false;
    });
  }
}
