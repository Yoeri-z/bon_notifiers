import 'package:flutter/foundation.dart';

/// Mixin for handling loading state.
mixin LoadingNotifierMixin on ChangeNotifier {
  bool _loading = true;

  /// Whether the notifier is in a loading state.
  bool get isLoading => _loading;

  /// Sets the loading state and notifies listeners.
  void setLoading() {
    _loading = true;
    notifyListeners();
  }

  /// Marks the notifier as no longer loading and notifies listeners.
  void setNotLoading() {
    _loading = false;
    notifyListeners();
  }
}
