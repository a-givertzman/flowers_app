import 'package:flowers_app/assets/texts/app_text.dart';
import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/auth/user_phone.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flutter/material.dart';

class PhoneNumbetWidget extends StatefulWidget {
  final UserPhone? userPhone;
  final void Function(UserPhone)? onCompleted;
  const PhoneNumbetWidget({
    Key? key,
    this.userPhone,
    this.onCompleted,
  }) : super(key: key);

  @override
  _PhoneNumbetWidgetState createState() => _PhoneNumbetWidgetState();
}

class _PhoneNumbetWidgetState extends State<PhoneNumbetWidget> {
  late UserPhone _userPhone;
  @override
  void initState() {
    if (mounted) {
      final widgetUserPhone = widget.userPhone;
      if (widgetUserPhone != null) {
        _userPhone = widgetUserPhone;
      } else {
        _userPhone = UserPhone(phone: '');
      }
    }
    log('[_PhoneNumbetWidgetState.initState] userPhone: ', _userPhone.numberWithCode());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    log('[_PhoneNumbetWidgetState.build] userPhone: ', _userPhone.numberWithCode());
    const paddingValue = 13.0;
    return Column(
      children: [
        RepaintBoundary(
          child: TextFormField(
            style: appThemeData.textTheme.bodyText2,
            keyboardType: TextInputType.number,
            maxLength: 10,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.phone,
                // color: appThemeData.colorScheme.onPrimary,
              ),
              prefixText: '+7',
              prefixStyle: appThemeData.textTheme.bodyText2,
              labelText: 'Номер телефона',
              labelStyle: appThemeData.textTheme.bodyText2,
              errorMaxLines: 3,
            ),
            autocorrect: false,
            initialValue: _userPhone.number(),
            validator: (value) => _userPhone.validate().message(),
            onChanged: (phone) {
              setState(() {
                _userPhone = UserPhone(phone: phone);
              });
            },
          ),
        ),
        const SizedBox(height: paddingValue),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _userPhone.validate().valid()
              ? _onComplete
              : null,
            child: const Text(AppText.next),
          ),
        ),
      ],
    );
  }
  void _onComplete() {
    FocusScope.of(context).unfocus();
    final widgetOnCompleted = widget.onCompleted;
    if (widgetOnCompleted != null) {
      widgetOnCompleted(_userPhone);
    }
  }
}
