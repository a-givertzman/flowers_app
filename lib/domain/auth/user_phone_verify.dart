import 'package:firebase_auth/firebase_auth.dart';
import 'package:flowers_app/dev/log/log.dart';

class UserPhoneVerify {
  final String _countryCode;
  final String _phone;
  final int _resendTimeout;
  final void Function(String, int?) _onCodeSent;
  final void Function(String) _onCodeAutoRetrievalTimeout;
  final void Function(PhoneAuthCredential) _onVerificationCompleted;
  final void Function(FirebaseAuthException exception) _onVerificationFailed;
  String _verificationId = '';
  int? _forceResendingToken;
  bool _completed = false;
  UserPhoneVerify({
    /// код страны, по умолчанию +7
    String? code,
    /// Номер телефона
    required String phone,
    // Через сколько секунд разрешить повторную отправку
    int? timeout,
    // когда смс код отправлен пользователю
    required void Function(String, int?) onCodeSent,
    // когда истек таймаут авто повтора
    required void Function(String) onCodeAutoRetrievalTimeout,
    // когда процедура проверки номера успешно закончена
    required void Function(PhoneAuthCredential) onVerificationCompleted,
    // когда процедура прервана или неудачно закончена
    required void Function(FirebaseAuthException exception) onVerificationFailed,
  }) :
    _countryCode = code ?? '+7',
    _phone = phone,
    _resendTimeout = timeout ?? 40,
    _onCodeAutoRetrievalTimeout = onCodeAutoRetrievalTimeout,
    _onCodeSent = onCodeSent,
    _onVerificationCompleted = onVerificationCompleted,
    _onVerificationFailed = onVerificationFailed;

  /// Returns true if phone number verified successful
  bool completed() => _completed;

  Future<bool> verifyOtp(String smsCode) async {
    log('[UserPhoneVerify.verifyOtp] smsCode: $smsCode');
    log('[UserPhoneVerify.verifyOtp] verificationId: $_verificationId');
    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId, 
      smsCode: smsCode,
    );
    log('[UserPhoneVerify.verifyOtp] credential: $credential');
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      return true;
    } catch (e) {
      log('[UserPhoneVerify.verifyOtp] auth error: $e');
      return false;
    }
  }
  /// Начало проверки номера телефона,
  /// отправляем смс-код
  Future<void> verifyPhone() async {
    final _firebaseAuth = FirebaseAuth.instance;
      try {
        log('[UserPhoneVerify.verifyPhone] trying to verify $_countryCode$_phone');
        await _firebaseAuth.setLanguageCode('ru');
        await _firebaseAuth.verifyPhoneNumber(
          //
          // forceResendingToken: _forceResendingToken,
          //
          phoneNumber: _countryCode + _phone, // PHONE NUMBER TO SEND OTP
          //
          codeAutoRetrievalTimeout: (String verificationId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            log('[codeAutoRetrievalTimeout] _verificationId: $verificationId');
            _forceResendingToken = null;
            _verificationId = verificationId;
            _onCodeAutoRetrievalTimeout(verificationId);
          },
          //
          timeout: Duration(seconds: _resendTimeout),
          //
          codeSent: (String verificationId, int? forceResendingToken) {
            log('[codeSent]: ');
            _forceResendingToken = forceResendingToken;
            _verificationId = verificationId;
            _onCodeSent(verificationId, forceResendingToken);   // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          },
          //
          verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
            _completed = true;
            _forceResendingToken = null;
            log('[verificationCompleted]: $phoneAuthCredential');
            _onVerificationCompleted(phoneAuthCredential);
          },
          //
          verificationFailed: (FirebaseAuthException exception) {
            _forceResendingToken = null;
            log('[verificationFailed] ${exception.message}');
            _onVerificationFailed(exception);
          },
        );
      } catch (e) {
          handleError(e);
      }
  }

  void handleError(Object error) {
      log('[UserPhoneVerify.verifyPhone->handleError] error: ', error);
    if (error is FirebaseAuthException) {
      switch (error.code) {
          case 'ERROR_INVALID_VERIFICATION_CODE':
          // FocusScope.of(context).requestFocus(new FocusNode());
          // setState(() {
          //     errorMessage = 'Invalid Code';
          // });
          // Navigator.of(context).pop();
          // smsOTPDialog(context).then((value) {
          //     log('[UserPhoneVerify.verifyPhone->handleError] sign in');
          // });
          break;
          default:
          // setState(() {
          //     errorMessage = error.message;
          // });

          break;
      }
    }
  }
}
