//
// Ganeral Value Failures
abstract class ValueFailure<T> {
  factory ValueFailure({required T message, }) {
    // TODO: implement 
    throw UnimplementedError();
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
