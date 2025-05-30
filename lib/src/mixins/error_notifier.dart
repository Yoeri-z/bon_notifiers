import 'package:flutter/foundation.dart';

/// Mixin for handling error state.
mixin ErrorNotifier on ChangeNotifier {
  Object? _error;

  /// The error state of the notifier.
  Object? get error => _error;

  /// Whether there is an error.
  bool get hasError => _error != null;

  /// Sets the error state and notifies listeners.
  void setError(Object error) {
    _error = error;
    notifyListeners();
  }

  /// Clears the error state and notifies listeners.
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
