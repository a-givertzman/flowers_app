import 'package:firebase_auth/firebase_auth.dart';
import 'package:flowers_app/domain/core/entities/validation_result.dart';

class UserPhone {
  final String _countryCode = '+7';
  final String _phone;
  final void Function(String, int?) _onCodeSent;
  final void Function(String) _onCodeAutoRetrievalTimeout;
  final void Function(PhoneAuthCredential) _onCompleted;
  void Function(FirebaseAuthException exception) _onVerificationFailed;
  String _verificationId = '';
  int? _forceResendingToken = null;
  bool _completed = false;
  UserPhone({
    required phone,
    required void Function(String, int?) onCodeSent,
    required void Function(String) onCodeAutoRetrievalTimeout,
    required void Function(PhoneAuthCredential) onCompleted,
    required void Function(FirebaseAuthException exception) onVerificationFailed,
  }) :
    _phone = phone,
    _onCodeAutoRetrievalTimeout = onCodeAutoRetrievalTimeout,
    _onCodeSent = onCodeSent,
    _onCompleted = onCompleted,
    _onVerificationFailed = onVerificationFailed;
  ValidationResult validate() {
    RegExp regex = RegExp(r"^[0-9]{10}$");
    final _valid = regex.hasMatch(_phone);
    return ValidationResult(
      valid: _valid,
      message: _valid ? null : 'Номер должен состоять из 10 цифр без пробелов и других символов, например 9554443322',
    );
  }
  String value() => _phone;
  bool completed() => _completed;

  Future<bool> verifyOtp(String smsCode) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId, 
      smsCode: smsCode
    );
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      print('[UserPhone.verifyOtp] success!: $credential');
      return true;
    } catch (e) {
      print('[UserPhone.verifyOtp] auth error: $e');
      return false;
    }
  }
  Future<void> verifyPhone() async {
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

      try {
        await _firebaseAuth.setLanguageCode('ru');
        print('[UserPhone.verifyPhone] trying to verify $_countryCode$_phone');
        _firebaseAuth.setLanguageCode('');
        await _firebaseAuth.verifyPhoneNumber(
          // forceResendingToken: _forceResendingToken,
          phoneNumber: _countryCode + _phone, // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            print('[codeAutoRetrievalTimeout] _verificationId: $verId');
            _forceResendingToken = null;
            _verificationId = verId;
            _onCodeAutoRetrievalTimeout(verId);
          },
          timeout: const Duration(seconds: 40),
          codeSent: (String verificationId, int? forceResendingToken) {
            _forceResendingToken = forceResendingToken;
            _verificationId = verificationId;
            _onCodeSent(verificationId, forceResendingToken);   // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          },
          verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
            _completed = true;
            _forceResendingToken = null;
            print('[verificationCompleted]: $phoneAuthCredential');
            await _firebaseAuth.signOut();
            _onCompleted(phoneAuthCredential);
          },
          verificationFailed: (FirebaseAuthException exception) {
            _forceResendingToken = null;
            print('[verificationFailed] ${exception.message}');
          }
        );
      } catch (e) {
          handleError(e);
      }
  }

  handleError(Object error) {
      print(error);
    if (error is FirebaseAuthException) {
      switch (error.code) {
          case 'ERROR_INVALID_VERIFICATION_CODE':
          // FocusScope.of(context).requestFocus(new FocusNode());
          // setState(() {
          //     errorMessage = 'Invalid Code';
          // });
          // Navigator.of(context).pop();
          // smsOTPDialog(context).then((value) {
          //     print('sign in');
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
