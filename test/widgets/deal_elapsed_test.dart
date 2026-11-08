import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_barrio/app/theme/app_theme.dart';
import 'package:red_barrio/features/proposals/presentation/deal_timeline.dart';

void main() {
  testWidgets('el cronómetro avanza cada segundo sin que nada más redibuje', (
    tester,
  ) async {
    var now = DateTime(2026, 11, 8, 10, 0, 0);
    final since = now;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: DealElapsed(since: since, now: () => now),
        ),
      ),
    );
    expect(find.text('00:00'), findsOneWidget);

    now = now.add(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('00:01'), findsOneWidget);

    now = now.add(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('00:02'), findsOneWidget);
  });
}
