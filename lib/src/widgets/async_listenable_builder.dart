// ignore_for_file: null_check_on_nullable_type_parameter

import 'package:bon_notifiers/bon_notifiers.dart';
import 'package:flutter/material.dart';

/// Signature for building a widget from a successful result.
typedef AsyncListenableResultBuilder<T> =
    Widget Function(BuildContext context, T result, Widget? child);

/// Signature for building a widget from an error.
typedef AsyncListenableErrorBuilder<T> =
    Widget Function(BuildContext context, Object error, Widget? child);

/// A widget that builds itself based on the state of an [AsyncListenable].
///
/// It handles loading, error, and result states using the provided builder functions.
class AsyncListenableBuilder<T> extends StatefulWidget {
  const AsyncListenableBuilder({
    super.key,
    required this.asyncListenable,
    required this.resultBuilder,
    required this.errorBuilder,
    this.loadingIndicator,
    this.child,
  });

  /// The [AsyncListenable] to listen to for updates.
  final AsyncListenable<T> asyncListenable;

  /// Called when [asyncListenable] has a result.
  final AsyncListenableResultBuilder<T> resultBuilder;

  /// Called when [asyncListenable] has an error.
  final AsyncListenableErrorBuilder errorBuilder;

  /// A widget that is displayed when the [asyncListenable] is loading.
  ///
  /// If no [loadingIndicator] is provided, a default [CircularProgressIndicator.adaptive] is shown.
  final Widget? loadingIndicator;

  /// A widget that is passed unchanged to the [resultBuilder] and [errorBuilder].
  ///
  /// This allows preserving static parts of the widget tree that do not depend on the result
  /// or error, improving performance and readability.
  ///
  /// Example:
  /// ```dart
  /// AsyncListenableBuilder<Counter>(
  ///   asyncListenable: context.read(),
  ///   resultBuilder: (_, __, ___) => Placeholder(),
  ///   errorBuilder: (_, __, child) => child!,
  ///   child: Text('Something went wrong'),
  /// )
  /// ```
  final Widget? child;

  @override
  State<AsyncListenableBuilder<T>> createState() =>
      _AsyncListenableBuilderState<T>();
}

class _AsyncListenableBuilderState<T> extends State<AsyncListenableBuilder<T>> {
  AsyncListenable<T> get listenable => widget.asyncListenable;

  @override
  void initState() {
    super.initState();
    listenable.addListener(_changed);
  }

  @override
  void didUpdateWidget(AsyncListenableBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.asyncListenable != listenable) {
      oldWidget.asyncListenable.removeListener(_changed);
      listenable.addListener(_changed);
    }
  }

  @override
  void dispose() {
    widget.asyncListenable.removeListener(_changed);
    super.dispose();
  }

  void _changed() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (listenable.hasError) {
      return widget.errorBuilder(context, listenable.error!, widget.child);
    }
    if (listenable.isLoading) {
      return widget.loadingIndicator ??
          const CircularProgressIndicator.adaptive(
            constraints: BoxConstraints(maxHeight: 40, maxWidth: 40),
          );
    }

    assert(
      listenable.hasResult,
      'AsyncListenable reached an impossible state: there is no error, it is not loading, and it has no result.\n'
      'If you are using AsyncNotifier, this should never happen.\n'
      'If you implemented your own AsyncListenable, make sure it always reflects one of the three valid states.',
    );

    return widget.resultBuilder(context, listenable.result!, widget.child);
  }
}
