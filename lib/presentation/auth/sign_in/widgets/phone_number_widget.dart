import 'package:flowers_app/domain/auth/user_phone.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flutter/material.dart';

class PhoneNumbetWidget extends StatefulWidget {
  final void Function(UserPhone)? onCompleted;
  const PhoneNumbetWidget({
    Key? key,
    this.onCompleted,
  }) : super(key: key);

  @override
  _PhoneNumbetWidgetState createState() => _PhoneNumbetWidgetState();
}

class _PhoneNumbetWidgetState extends State<PhoneNumbetWidget> {
  late UserPhone _userPhone;
  _PhoneNumbetWidgetState() {
    _userPhone = UserPhone(phone: '');
  }
  @override
  Widget build(BuildContext context) {
    const paddingValue = 13.0;
    return Column(
      children: [
        RepaintBoundary(
          child: TextFormField(
            style: appThemeData.textTheme.bodyText2,
            keyboardType: TextInputType.number,
            maxLength: 10,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.phone,
                color: appThemeData.colorScheme.onPrimary,
              ),
              prefixText: '+7',
              prefixStyle: appThemeData.textTheme.bodyText2,
              labelText: 'Номер телефона',
              labelStyle: appThemeData.textTheme.bodyText2,
              errorMaxLines: 3,
            ),
            autocorrect: false,
            validator: (value) => _userPhone.validate().message(),
            onChanged: (phone) {
              setState(() {
                _userPhone = UserPhone(phone: phone);
              });
            },
          ),
        ),
        const SizedBox(height: paddingValue),
        ElevatedButton(
          onPressed: _userPhone.validate().valid()
            ? _onComplete
            : null,
          child: const Text('Отправить код'),
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
