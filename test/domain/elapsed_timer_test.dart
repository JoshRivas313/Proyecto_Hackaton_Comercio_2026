import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_barrio/features/proposals/presentation/elapsed_timer.dart';

void main() {
  test('formato mm:ss y nunca negativo', () {
    expect(formatElapsed(const Duration(seconds: 1)), '00:01');
    expect(formatElapsed(const Duration(minutes: 12, seconds: 5)), '12:05');
    expect(formatElapsed(const Duration(seconds: -4)), '00:00');
  });

  testWidgets(
    'regresión: el temporizador sigue avanzando (no se queda en 00:01)',
    (tester) async {
      var now = DateTime(2026, 11, 8, 10, 0, 0);
      final since = now;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ElapsedTimer(since: since, now: () => now),
          ),
        ),
      );
      expect(find.text('00:00'), findsOneWidget);

      for (var s = 1; s <= 5; s++) {
        now = now.add(const Duration(seconds: 1));
        await tester.pump(const Duration(seconds: 1));
      }
      expect(find.text('00:05'), findsOneWidget);

      // Pasa un minuto "en segundo plano": al reanudar se recalcula con la hora real.
      now = now.add(const Duration(seconds: 60));
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
      expect(find.text('01:05'), findsOneWidget);
    },
  );

  testWidgets('al salir de la pantalla se cancela el temporizador', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: ElapsedTimer(since: DateTime(2026, 11, 8))),
      ),
    );
    await tester.pumpWidget(const MaterialApp(home: Scaffold()));
    // Si quedara un Timer activo, la prueba fallaría por "Timer still pending".
    await tester.pump(const Duration(seconds: 2));
  });
}
