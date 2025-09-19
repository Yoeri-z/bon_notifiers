import 'package:flutter/widgets.dart';

/// A function that handles warnings or errors.
/// Receives an [Object] representing the error.
typedef WarnFunction = void Function(Object error);

/// An interface for asynchronous data sources that notify listeners about changes.
///
/// Typically used in state management to track and expose the state of an
/// asynchronous operation (e.g., loading, success, error).
abstract interface class AsyncListenable extends Listenable {
  /// Indicates whether the asynchronous operation is currently loading.
  bool get isLoading;

  /// Indicated wether or not the notifier has data
  bool get hasData;

  /// Indicates whether an error occurred during the operation.
  bool get hasError;

  /// The error that occurred, if any. `null` if no error occurred.
  Object? get error;

  static void Function(
    String message,
    Object error,
    StackTrace stackTrace,
  )? errorListener;
}
