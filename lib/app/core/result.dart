/// Represents the result of an operation that can either succeed with a value of type [T]
/// or fail with an error of type [E].
sealed class Result<T, E> {
  const Result();

  /// Creates a successful result containing the given [value].
  factory Result.success(T value) = Success<T, E>;

  /// Creates a failure result containing the given [error].
  factory Result.failure(E error) = Failure<T, E>;

  /// Transforms the success value using the given [mapper] function.
  Result<R, E> map<R>(R Function(T value) mapper);

  /// Transforms the error value using the given [mapper] function.
  Result<T, R> mapError<R>(R Function(E error) mapper);

  /// Returns the success value if this is a [Success], otherwise returns [defaultValue].
  T getOrElse(T defaultValue);

  /// Returns true if this result is a [Success].
  bool get isSuccess;

  /// Returns true if this result is a [Failure].
  bool get isFailure;

  /// Executes [onSuccess] if this is a [Success], or [onFailure] if this is a [Failure].
  R fold<R>(R Function(T value) onSuccess, R Function(E error) onFailure);
}

/// Represents a successful result containing a value of type [T].
final class Success<T, E> extends Result<T, E> {
  final T value;

  const Success(this.value);

  @override
  Result<R, E> map<R>(R Function(T value) mapper) {
    return Success(mapper(value));
  }

  @override
  Result<T, R> mapError<R>(R Function(E error) mapper) {
    return Success(value);
  }

  @override
  T getOrElse(T defaultValue) => value;

  @override
  bool get isSuccess => true;

  @override
  bool get isFailure => false;

  @override
  R fold<R>(R Function(T value) onSuccess, R Function(E error) onFailure) {
    return onSuccess(value);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Success<T, E> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Success($value)';
}

/// Represents a failed result containing an error of type [E].
final class Failure<T, E> extends Result<T, E> {
  final E error;

  const Failure(this.error);

  @override
  Result<R, E> map<R>(R Function(T value) mapper) {
    return Failure(error);
  }

  @override
  Result<T, R> mapError<R>(R Function(E error) mapper) {
    return Failure(mapper(error));
  }

  @override
  T getOrElse(T defaultValue) => defaultValue;

  @override
  bool get isSuccess => false;

  @override
  bool get isFailure => true;

  @override
  R fold<R>(R Function(T value) onSuccess, R Function(E error) onFailure) {
    return onFailure(error);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure<T, E> && other.error == error;
  }

  @override
  int get hashCode => error.hashCode;

  @override
  String toString() => 'Failure($error)';
}
