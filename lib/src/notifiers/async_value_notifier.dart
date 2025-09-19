import 'dart:async';

import 'package:bon_notifiers/bon_notifiers.dart';
import 'package:bon_notifiers/src/notifiers/async_notifier.dart';

typedef ActionCallback<T> = FutureOr<T> Function(T data);

/// A concrete implementation of [AsyncValueListenable].
///
/// Manages the state of an asynchronous value of type [T], including loading,
/// result, and error states. Notifies listeners on updates.
class AsyncValueNotifier<T> extends AsyncNotifier
    implements AsyncValueListenable<T> {
  T? _data;

  /// Creates an [AsyncValueNotifier] with an optional initial [data].
  ///
  /// If [data] is provided, the notifier starts in a non-loading state.
  AsyncValueNotifier({T? data}) : _data = data {
    setNotLoading();
  }

  @override
  bool get hasData => _data != null;

  @override
  T? get data => _data;

  @override
  T get requireData => data!;

  @override
  bool get isLoading => super.isLoading || !hasData;

  ///Set the data to a value
  set data(T? data) {
    if (_data == data) return;

    _data ??= data;

    notifyListeners();
  }

  ///Sets the result to be the returned value of [action].
  ///The notifier will automatically enter a loading state for the duration of [action].
  ///If [action] fails, [error] will be set automatically.
  ///
  /// An error message can be set in [message].
  ///
  /// To disable the notifier entering loading state, set [autoSetLoading] to false
  Future<void> update(
    ActionCallback<T> action, {
    String? message,
    bool autoSetLoading = true,
  }) async {
    if (!hasData || hasError) return;
    data = await runFuture(action(requireData),
        message: message, autoSetLoading: autoSetLoading);
  }
}
