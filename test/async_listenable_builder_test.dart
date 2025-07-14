import 'package:bon_notifiers/bon_notifiers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows loading by default', (tester) async {
    final notifier = AsyncNotifier<String>();

    await tester.pumpWidget(
      MaterialApp(
        home: AsyncListenableBuilder<String>(
          asyncListenable: notifier,
          resultBuilder: (_, result, __) => Text(result),
          errorBuilder: (_, error, __) => Text('Error: $error'),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows result when available', (tester) async {
    final notifier = AsyncNotifier<String>(value: 'hello');

    await tester.pumpWidget(
      MaterialApp(
        home: AsyncListenableBuilder<String>(
          asyncListenable: notifier,
          resultBuilder: (_, result, __) => Text(result),
          errorBuilder: (_, error, __) => Text('Error: $error'),
        ),
      ),
    );

    expect(find.text('hello'), findsOneWidget);
  });

  testWidgets('shows error when set', (tester) async {
    final notifier = AsyncNotifier<String>();
    notifier.setError('crash', 'crash', StackTrace.current);

    await tester.pumpWidget(
      MaterialApp(
        home: AsyncListenableBuilder<String>(
          asyncListenable: notifier,
          resultBuilder: (_, result, __) => Text(result),
          errorBuilder: (_, error, __) => Text('Error: $error'),
        ),
      ),
    );

    expect(find.text('Error: crash'), findsOneWidget);
  });

  testWidgets('child is passed through to resultBuilder', (tester) async {
    final notifier = AsyncNotifier<String>(value: 'data');

    await tester.pumpWidget(
      MaterialApp(
        home: AsyncListenableBuilder<String>(
          asyncListenable: notifier,
          resultBuilder:
              (_, __, child) =>
                  Column(children: [Text('result'), if (child != null) child]),
          errorBuilder: (_, __, ___) => SizedBox(),
          child: Text('static'),
        ),
      ),
    );

    expect(find.text('result'), findsOneWidget);
    expect(find.text('static'), findsOneWidget);
  });
}
