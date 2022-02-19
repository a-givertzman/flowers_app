
// ignore_for_file: avoid_classes_with_only_static_members

import 'package:flowers_app/dev/log/log.dart';

enum AppLang {en, ru, de, fr}
const appLang = AppLang.ru;
class AppText {
  static const ok = 'Ok';
  static const next = 'Далее';
  static const welcome = 'Добро пожаловать!';
  static const jointPurchases = 'Совместные закупки!';
  static const loading = 'Загружаю...';
  static const pleaseAuthenticateToContinue = 'Авторизуйтесь что бы продолжить...';
  static const pleaseEnterYourJointPurchasesNumber = 'Введите ваш номер в закупках';
  static const pleaseEnterYourPassword = 'Введите ваш пароль';
  static const yourNumber = 'Ваш номер';
  static const yourPassword = 'Ваш пароль';
  static const wrongNumber = 'Неверный номер';
  static const wrongPass = 'Неверный пароль';
  static const smsCode = 'смс - код';
  static const pleaseEnterYour6DigitsSmsCode = 'Введите 6-ти значный код из смс';
  static const wrongCode = 'Неверный код';
  static const sendCode = 'Отправить код';
  static const pleaseCheckYourPhoneNumberOrTryAgainLate = 'Проверьте номер телефона или попробуте еще раз познее';
  static const error = 'Ошибка';
  static const userAccount = 'Личный кабинет';
  static const authentication = 'Авторизация';
  static const signingUp = 'Регистрация';
  static const changePassword = 'Сменить пароль';
  static const changingPassword = 'Смена пароля';
  static const settingsPage = 'Настройки';
  static const userLogout = 'Выйти их профиля';
  static const purchases = 'Закупки';
  static const noNotines = 'Сообщений нет';
  static final _map = <String, List<String>>{
    'Ok': ['Ok',],
    'Next': ['Далее',],
    'Welcome': ['Добро пожаловать',],
    'Joint purchases': ['Совместные закупки',],
    'Loading...': ['Загружаю...',],
    'Please authenticate to continue...': ['Авторизуйтесь что бы продолжить...',],
    'Please enter your joint purchases number': ['Введите ваш номер в закупках',],
    'Please enter your password': ['Введите ваш пароль',],
    'Your number': ['Ваш номер',],
    'Your password': ['Ваш пароль',],
    'Wrong number': ['Неверный номер',],
    'Wrong password': ['Неверный пароль',],
    'sms - code': ['смс - код',],
    'Please enter your 6 digits sms - code': ['Введите 6-ти значный код из смс',],
    'Wrong code': ['Неверный код',],
    'Send code': ['Отправить код',],
    'Please check your phone number or try again late': ['Проверьте номер телефона или попробуте еще раз познее',],
    'Error': ['Ошибка',],
    'User account': ['Личный кабинет',],
    'Authentication': ['Авторизация',],
    'Signing up': ['Регистрация',],
    'Change password': ['Сменить пароль',],
    'Changing password': ['Смена пароля',],
    'Settings page': ['Настройки',],
    'User logout': ['Выйти их профиля',],
    'Purchases': ['Закупки',],
    'No notines': ['Сообщений нет',],
  };
  static String tr(String text, {AppLang? lng}) {
    final AppLang _lng = lng ?? appLang;
    if (_lng == AppLang.en) {
      return text;
    }
    if (_map.containsKey(text)) {
      return (_map[text] ?? [])[_lng.index];
    }
    log('[$AppText.tr] нет перевода для "$text"');
    return text;
  }
}
