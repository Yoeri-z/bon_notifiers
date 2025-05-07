// ignore_for_file: null_check_on_nullable_type_parameter

import 'package:bon_notifiers/bon_notifiers.dart';
import 'package:flutter/cupertino.dart';

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
  void setError(Object error, [StackTrace? st]) {
    _error = error;
    notifyListeners();
  }

  /// Marks the notifier as loading and notifies listeners.
  void setLoading() {
    _loading = true;
    notifyListeners();
  }

  /// Updates the current result using the provided [updater] function.
  ///
  /// If an error exists and [warnCallback] is provided, it will be called with the error.
  /// Throws if called before the notifier has been initialized with a result.
  ///
  /// If you're unsure whether the [AsyncNotifier] has a result at this point, use [set] instead.
  void update(ResultUpdateFunction<T> updater, [WarnFunction? warnCallback]) {
    if (hasError) {
      if (warnCallback != null) {
        warnCallback(error!);
      }
      return;
    }
    if (hasResult) {
      _result = updater(result!);
      _loading = false;
      notifyListeners();
      return;
    }
    assert(() {
      throw BonError(
        message:
            '[update] was called before a result value was set; make sure the [AsyncNotifier] has '
            'a value by passing the first value you retrieve to [set] instead of [update].',
      );
    }());
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
}
