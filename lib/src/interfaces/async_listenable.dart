import 'package:flutter/widgets.dart';

/// A function that takes the current result of type [T] and returns an updated result.
/// Useful for performing transformations or updates in a functional style.
typedef ResultUpdateFunction<T> = T Function(T result);

/// A function that handles warnings or errors.
/// Receives an [Object] representing the error.
typedef WarnFunction = void Function(Object error);

/// An interface for asynchronous data sources that notify listeners about changes.
///
/// Typically used in state management to track and expose the state of an
/// asynchronous operation (e.g., loading, success, error).
abstract interface class AsyncListenable<T> extends Listenable {
  /// Indicates whether the asynchronous operation is currently loading.
  bool get isLoading;

  /// Indicates whether a valid result is available.
  bool get hasResult;

  /// Indicates whether an error occurred during the operation.
  bool get hasError;

  /// The current result, if available. May be `null` if not yet loaded or if an error occurred.
  T? get result;

  /// The current result, fails if it is not available.
  T get requireResult;

  /// The error that occurred, if any. `null` if no error occurred.
  Object? get error;
}
