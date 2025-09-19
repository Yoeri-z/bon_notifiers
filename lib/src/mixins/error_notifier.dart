import 'package:bon_notifiers/bon_notifiers.dart';
import 'package:flutter/foundation.dart';

/// Mixin for handling error state.
mixin ErrorNotifierMixin on ChangeNotifier {
  Object? _error;

  /// The error state of the notifier.
  Object? get error => _error;

  /// Whether there is an error.
  bool get hasError => _error != null;

  /// Sets the error state and notifies listeners.
  void setError(Object error, {String? message, StackTrace? stackTrace}) {
    _error = error;
    if (message != null) {
      AsyncListenable.errorListener?.call(
        message,
        error,
        stackTrace ?? StackTrace.current,
      );
    }
    notifyListeners();
  }

  /// Clears the error state and notifies listeners.
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
