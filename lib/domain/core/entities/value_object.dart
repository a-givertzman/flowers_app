abstract class ValueObject<T> {
  T? _v;
  void set(T value) {
    _v = value;
  }
  toDomain(T value) {
    _v = value;
  }
  T? get() => _v;
}
