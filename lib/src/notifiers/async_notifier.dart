import 'dart:async';

import 'package:bon_notifiers/bon_notifiers.dart';
import 'package:flutter/foundation.dart';

typedef ErrorCallback = void Function(Object error, StackTrace stackTrace);

/// A concrete implementation of [AsyncListenable].
///
/// Manages the state of an asynchronous value of type [T], including loading,
/// result, and error states. Notifies listeners on updates.
class AsyncNotifier extends ChangeNotifier
    with ErrorNotifierMixin, LoadingNotifierMixin
    implements AsyncListenable {
  /// Creates an [AsyncNotifier].
  ///
  /// AsyncNotifier always is in loading state after its construction.
  AsyncNotifier();

  @override
  bool get hasData => !isLoading && !hasError;

  ///Safely runs a future and catches any error.
  ///
  ///If [AsyncListenable.errorListener] is set errors will be propegated to that callback.
  ///
  ///Use [message] to send a custom message along with the error to the errorlistener.
  ///
  ///To catch the error locally, provide [onError] callback. If [onError] is provided,
  ///the message will not be sent to [AsyncListenable.errorListener].
  Future<T?> runFuture<T>(
    FutureOr<T> future, {
    String? message,
    ErrorCallback? onError,
    bool autoSetLoading = true,
  }) async {
    try {
      if (autoSetLoading) setLoading();
      final result = await future;
      setNotLoading();
      return result;
    } catch (e, st) {
      if (onError != null) {
        onError(e, st);
      } else {
        setError(e, message: message, stackTrace: st);
      }
      return null;
    }
  }
}
