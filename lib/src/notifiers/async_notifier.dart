// ignore_for_file: null_check_on_nullable_type_parameter

import 'package:bon_notifiers/bon_notifiers.dart';
import 'package:flutter/foundation.dart';

/// A concrete implementation of [AsyncListenable].
///
/// Manages the state of an asynchronous value of type [T], including loading,
/// result, and error states. Notifies listeners on updates.
class AsyncNotifier<T> extends ChangeNotifier implements AsyncListenable<T> {
  /// Creates an [AsyncNotifier] with an optional initial [value].
  ///
  /// If [value] is provided, the notifier starts in a non-loading state.
  AsyncNotifier({T? value}) : _result = value {
    if (value != null) {
      _loading = false;
    }
  }

  Object? _error;

  @override
  Object? get error => _error;

  @override
  bool get hasError => error != null;

  T? _result;

  @override
  bool get hasResult => _result != null;

  @override
  T? get result => _result;

  bool _loading = true;

  @override
  bool get isLoading => _loading;

  /// Sets an [error] and notifies listeners.
  void setError(String message, Object error, [StackTrace? st]) {
    _error = error;
    if (errorListener != null) {
      errorListener!(message, error, this, st);
    }
    notifyListeners();
  }

  /// Marks the notifier as loading and notifies listeners.
  void setLoading() {
    _loading = true;
    notifyListeners();
  }

  /// Sets the result to [value] and notifies listeners.
  ///
  /// This will clear any previous errors and overwrite the existing result.
  /// If you want to preserve errors, use [update] instead.
  void set(T value) {
    _result = value;
    _error = null;
    _loading = false;
    notifyListeners();
  }

  static void Function(
    String message,
    Object error,
    ChangeNotifier notifier,
    StackTrace? stackTrace,
  )?
  errorListener;
}
