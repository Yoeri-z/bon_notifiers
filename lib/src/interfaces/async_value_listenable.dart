import 'package:bon_notifiers/bon_notifiers.dart';

abstract interface class AsyncValueListenable<T> implements AsyncListenable {
  /// The current result, if available. May be `null` if not yet loaded or if an error occurred.
  T? get data;

  /// The current result, fails if it is not available.
  T get requireData;
}
