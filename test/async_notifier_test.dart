import 'package:bon_notifiers/bon_notifiers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AsyncNotifier', () {
    test('initial state with value is not loading and has result', () {
      final notifier = AsyncNotifier<int>(value: 42);

      expect(notifier.isLoading, isFalse);
      expect(notifier.hasResult, isTrue);
      expect(notifier.result, equals(42));
    });

    test('initial state without value is loading and has no result', () {
      final notifier = AsyncNotifier<int>();

      expect(notifier.isLoading, isTrue);
      expect(notifier.hasResult, isFalse);
    });

    test('set sets the result and deflags loading', () {
      final notifier = AsyncNotifier<String>();
      notifier.set('hello');

      expect(notifier.result, equals('hello'));
      expect(notifier.isLoading, isFalse);
    });

    test('setError sets error and notifies listeners', () {
      final notifier = AsyncNotifier();
      bool notified = false;
      notifier.addListener(() => notified = true);

      final error = Exception('fail');
      notifier.setError(error);

      expect(notifier.hasError, isTrue);
      expect(notifier.error, equals(error));
      expect(notified, isTrue);
    });

    test('update modifies existing result', () {
      final notifier = AsyncNotifier<int>(value: 2);
      notifier.update((val) => val * 2);

      expect(notifier.result, equals(4));
    });

    test('update triggers warnCallback when error present', () {
      final notifier = AsyncNotifier<int>();
      final error = Exception('fail');
      Object? caught;
      notifier.setError(error);

      notifier.update((v) => v, (e) => caught = e);

      expect(caught, equals(error));
    });

    test('set new value clears error', () {
      final notifier = AsyncNotifier<String>();
      notifier.setError('crash');
      expect(notifier.hasError, isTrue);

      notifier.set('new value');
      expect(notifier.hasError, isFalse);
      expect(notifier.result, 'new value');
    });
  });
}
