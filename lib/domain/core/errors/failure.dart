//
// Ganeral Value Failures
import 'package:flowers_app/dev/log/log.dart';

abstract class Failure<T> {
  late T message;

  factory Failure({
    required T message, 
    required StackTrace stackTrace,
  }) {
    log(message);
    log(stackTrace);
    throw UnimplementedError(message.toString());
  }
  //
  // dataSource failure
  factory Failure.dataSource({
    required T message,
    required StackTrace stackTrace,
  }) => Failure(message: message, stackTrace: stackTrace);
  //
  // dataObject failure
  factory Failure.dataObject({
    required T message,
    required StackTrace stackTrace,
  }) => Failure(message: message, stackTrace: stackTrace);
  //
  // dataCollection failure
  factory Failure.dataCollection({
    required T message,
    required StackTrace stackTrace,
  }) => Failure(message: message, stackTrace: stackTrace);
  //
  // auth failure
  factory Failure.auth({
    required T message,
    required StackTrace stackTrace,
  }) => Failure(message: message, stackTrace: stackTrace);
  //
  // convertion failure
  factory Failure.convertion({
    required T message,
    required StackTrace stackTrace,
  }) => Failure(message: message, stackTrace: stackTrace);
  //
  // Connection failure
  factory Failure.connection({
    required T message,
    required StackTrace stackTrace,
  }) => Failure(message: message, stackTrace: stackTrace);
  //
  // Unexpected failure
  factory Failure.unexpected({
    required T message,
    required StackTrace stackTrace,
  }) => Failure(message: message, stackTrace: stackTrace);
}

abstract class ValueFailure<T> {
  factory ValueFailure({required T message, }) {
    // TODO: implement 
    throw UnimplementedError(message.toString());
  }
  //
  // Email failure
  factory ValueFailure.emailFailure({
    required T message,
  }) => ValueFailure(message: message);
  //
  // Password failure
  factory ValueFailure.passwordFailure({
    required T message,
  }) => ValueFailure(message: message);
  //
  // User Name failure
  factory ValueFailure.userNameFailure({
    required T message,
  }) => ValueFailure(message: message);
  //
  // Exceeding Notes length
  factory ValueFailure.exceedingLength({
    required T message,
    // required int maxLength,
  }) {
    // message += '\n максимимум $maxLength символов';
    return ValueFailure(message: message);
  } 
  //
  // Empty value failure
  factory ValueFailure.emptyValueFailure({
    required T failedValue,
  }) => ValueFailure(message: failedValue);
  //
  // Multiline failure
  factory ValueFailure.multylineValueFailure({
    required T failedValue,
  }) => ValueFailure(message: failedValue);
  //
  // ListTooLong failure
  factory ValueFailure.listTooLongFailure({
    required T failedValue,
    // required int maxLength,
  }) => ValueFailure(message: failedValue);
}
