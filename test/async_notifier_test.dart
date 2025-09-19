import 'package:bon_notifiers/bon_notifiers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AsyncValueNotifier', () {
    test('initial state with value is not loading and has result', () {
      final notifier = AsyncValueNotifier<int>(data: 42);

      expect(notifier.isLoading, isFalse);
      expect(notifier.hasData, isTrue);
      expect(notifier.data, equals(42));
    });

    test('initial state without value is loading and has no result', () {
      final notifier = AsyncValueNotifier<int>();

      expect(notifier.isLoading, isTrue);
      expect(notifier.hasData, isFalse);
    });

    test('set sets the result and deflags loading', () {
      final notifier = AsyncValueNotifier<String>();
      notifier.data = 'hello';

      expect(notifier.data, equals('hello'));
      expect(notifier.isLoading, isFalse);
    });

    test('setError sets error and notifies listeners', () {
      final notifier = AsyncValueNotifier();
      bool notified = false;
      notifier.addListener(() => notified = true);

      final error = Exception('fail');
      notifier.setError(error, stackTrace: StackTrace.current, message: 'fail');

      expect(notifier.hasError, isTrue);
      expect(notifier.error, equals(error));
      expect(notified, isTrue);
    });
  });
}
