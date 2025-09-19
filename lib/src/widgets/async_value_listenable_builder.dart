import 'package:bon_notifiers/bon_notifiers.dart';
import 'package:flutter/material.dart';

/// Signature for building a widget from a successful result.
typedef AsyncListenableResultBuilder<T> = Widget Function(
    BuildContext context, T result, Widget? child);

/// A widget that builds itself based on the state of an [AsyncListenable].
///
/// It handles loading, error, and result states using the provided builder functions.
class AsyncValueListenableBuilder<T> extends StatefulWidget {
  const AsyncValueListenableBuilder({
    super.key,
    required this.asyncListenable,
    required this.resultBuilder,
    required this.errorBuilder,
    this.loadingIndicator,
    this.child,
  });

  /// The [AsyncValueListenable] to listen to for updates.
  final AsyncValueListenable<T> asyncListenable;

  /// Called when [asyncListenable] has a result.
  final AsyncListenableResultBuilder<T> resultBuilder;

  /// Called when [asyncListenable] has an error.
  final ErrorBuilder errorBuilder;

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
  State<AsyncValueListenableBuilder<T>> createState() =>
      _AsyncValueListenableBuilderState<T>();
}

class _AsyncValueListenableBuilderState<T>
    extends State<AsyncValueListenableBuilder<T>> {
  AsyncValueListenable<T> get listenable => widget.asyncListenable;

  @override
  void initState() {
    super.initState();
    listenable.addListener(_changed);
  }

  @override
  void didUpdateWidget(AsyncValueListenableBuilder<T> oldWidget) {
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
          SizedBox(
            height: 40,
            width: 40,
            child: CircularProgressIndicator.adaptive(),
          );
    }

    return widget.resultBuilder(
      context,
      listenable.requireData,
      widget.child,
    );
  }
}
