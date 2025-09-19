import 'package:bon_notifiers/bon_notifiers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AsyncValueListenableBuilder', () {
    testWidgets('shows loading by default', (tester) async {
      final notifier = AsyncValueNotifier<String>();

      await tester.pumpWidget(
        MaterialApp(
          home: AsyncValueListenableBuilder<String>(
            asyncListenable: notifier,
            resultBuilder: (_, result, __) => Text(result),
            errorBuilder: (_, error, __) => Text('Error: $error'),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows result when available', (tester) async {
      final notifier = AsyncValueNotifier<String>(data: 'hello');

      await tester.pumpWidget(
        MaterialApp(
          home: AsyncValueListenableBuilder<String>(
            asyncListenable: notifier,
            resultBuilder: (_, result, __) => Text(result),
            errorBuilder: (_, error, __) => Text('Error: $error'),
          ),
        ),
      );

      expect(find.text('hello'), findsOneWidget);
    });

    testWidgets('shows error when set', (tester) async {
      final notifier = AsyncValueNotifier<String>();
      notifier.setError(
        'crash',
        stackTrace: StackTrace.current,
        message: 'crash',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: AsyncValueListenableBuilder<String>(
            asyncListenable: notifier,
            resultBuilder: (_, result, __) => Text(result),
            errorBuilder: (_, error, __) => Text('Error: $error'),
          ),
        ),
      );

      expect(find.text('Error: crash'), findsOneWidget);
    });

    testWidgets('child is passed through to resultBuilder', (tester) async {
      final notifier = AsyncValueNotifier<String>(data: 'data');

      await tester.pumpWidget(
        MaterialApp(
          home: AsyncValueListenableBuilder<String>(
            asyncListenable: notifier,
            resultBuilder: (_, __, child) =>
                Column(children: [Text('result'), if (child != null) child]),
            errorBuilder: (_, __, ___) => SizedBox(),
            child: Text('static'),
          ),
        ),
      );

      expect(find.text('result'), findsOneWidget);
      expect(find.text('static'), findsOneWidget);
    });
  });
}
