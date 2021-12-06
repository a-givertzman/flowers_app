// ignore_for_file: use_setters_to_change_properties

abstract class ValueObject<T> {
  T _v;
  ValueObject(T value) : _v = value;
  void set(T value) {
    _v = value;
  }
  void toDomain(String value) {
    _v = value as T;
  }
  T get() => _v;
}
