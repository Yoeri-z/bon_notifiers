import 'dart:async';

import 'package:bon_notifiers/bon_notifiers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

typedef ActionCallback<T> = FutureOr<T> Function(T value);

/// A concrete implementation of [AsyncListenable].
///
/// Manages the state of an asynchronous value of type [T], including loading,
/// result, and error states. Notifies listeners on updates.
class AsyncNotifier<T> extends ChangeNotifier implements AsyncListenable<T> {
  Object? _error;

  T? _result;

  bool _loading = true;

  /// Creates an [AsyncNotifier] with an optional initial [value].
  ///
  /// If [value] is provided, the notifier starts in a non-loading state.
  AsyncNotifier({T? value}) : _result = value {
    if (value != null) {
      _loading = false;
    }
  }

  @override
  Object? get error => _error;

  @override
  bool get hasError => error != null;

  @override
  bool get hasResult => _result != null;

  @override
  T? get result => _result;

  @override
  T get requireResult => result!;

  @override
  bool get isLoading => _loading;

  /// Sets an [error] and notifies listeners.
  void setError(Object error, {String? message, StackTrace? stackTrace}) {
    _error = error;
    if (message != null) {
      AsyncListenable.errorListener?.call(
        message,
        error,
        this,
        stackTrace ?? StackTrace.current,
      );
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

  ///Sets the result to be the returned value of [action].
  ///The notifier will automatically enter a loading state for the duration of [action].
  ///If [action] fails, [error] will be set automatically.
  ///
  /// An error message can be set in [errorMessage].
  ///
  /// To disable the notifier entering loading state, set [autoSetLoading] to false
  Future<void> update(
    ActionCallback<T> action, {
    String? errorMessage,
    bool autoSetLoading = true,
  }) async {
    if (!hasResult || hasError) return;
    if (autoSetLoading) setLoading();

    _error = null;
    try {
      final result = await action(requireResult);
      set(result);
    } catch (e, st) {
      setError(e, stackTrace: st, message: errorMessage);
    }
  }
}
