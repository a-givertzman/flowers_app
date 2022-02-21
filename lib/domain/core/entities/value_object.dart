// ignore_for_file: use_setters_to_change_properties

abstract class ValueObject<T> {
  final T _v;
  ValueObject(T value) : _v = value;
  // void set(T value) {
  //   _v = value;
  // }
  ValueObject<T> toDomain(String value);
  T get() => _v;
  @override
  bool operator ==(Object other) {
    if (other is ValueObject) {
      return other.get() == _v;
    }
    return false;
  }
  @override
  int get hashCode => _v.hashCode;
}
