//
// Ganeral Value Failures
import 'package:flowers_app/domain/core/errors/errors.dart';

abstract class Failure<T> {
  late T message;
  factory Failure({required message}) {
    print(message);
    throw UnimplementedError(message.toString());
  }
  //
  // dataSource failure
  factory Failure.dataSource({
    required T message,
  }) => Failure(message: message);
  //
  // dataObject failure
  factory Failure.dataObject({
    required T message,
  }) => Failure(message: message);
  //
  // dataCollection failure
  factory Failure.dataCollection({
    required T message,
  }) => Failure(message: message);
  //
  // auth failure
  factory Failure.auth({
    required T message,
  }) => Failure(message: message);
  //
  // convertion failure
  factory Failure.convertion({
    required T message,
  }) => Failure(message: message);
  //
  // Connection failure
  factory Failure.connection({
    required T message,
  }) => Failure(message: message);
  //
  // Unexpected failure
  factory Failure.unexpected({
    required T message,
  }) => Failure(message: message);
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
    required int maxLength,
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
    required int maxLength,
  }) => ValueFailure(message: failedValue);
}
