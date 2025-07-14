import 'package:bon_notifiers/src/notifiers/async_notifier.dart';
import 'package:flutter/foundation.dart';

/// Mixin for handling error state.
mixin ErrorNotifier on ChangeNotifier {
  Object? _error;

  /// The error state of the notifier.
  Object? get error => _error;

  /// Whether there is an error.
  bool get hasError => _error != null;

  /// Sets the error state and notifies listeners.
  void setError(String message, Object error, [StackTrace? stackTrace]) {
    _error = error;
    if (AsyncNotifier.errorListener != null) {
      AsyncNotifier.errorListener!(message, error, this, stackTrace);
    }
    notifyListeners();
  }

  /// Clears the error state and notifies listeners.
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
