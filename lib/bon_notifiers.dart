library;

export 'src/interfaces/async_listenable.dart';
export 'src/notifiers/async_notifier.dart';
export 'src/widgets/async_listenable_builder.dart';
export 'src/mixins/error_notifier.dart';
export 'src/mixins/loading_notifier.dart';

class BonError extends Error {
  BonError({required this.message});

  final String message;

  @override
  String toString() {
    return 'Bon Error: $message';
  }
}
