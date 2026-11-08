import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di/providers.dart';

/// Vacía la cola de pendientes al abrir la app y cada vez que cambia la conexión
/// (R14: no depender de tareas en segundo plano).
///
/// Cuando vuelve la señal, el teléfono avisa «hay internet» ANTES de que la red responda de
/// verdad: el primer intento puede fallar. Por eso, si quedan pendientes, se reintenta con
/// esperas cada vez más largas, sin que la persona tenga que tocar nada.
class SyncController extends Notifier<bool> {
  /// Esperas entre reintentos automáticos. Visible para las pruebas.
  @visibleForTesting
  static List<Duration> retryDelays = const [
    Duration(seconds: 3),
    Duration(seconds: 8),
    Duration(seconds: 20),
  ];

  Timer? _retry;
  bool _disposed = false;

  @override
  bool build() {
    _disposed = false;
    final sub = ref.read(connectivityProvider).onlineChanges.listen((online) {
      if (online) flushNow();
    });
    ref.onDispose(() {
      _disposed = true;
      _retry?.cancel();
      sub.cancel();
    });
    Future.microtask(flushNow);
    return false; // true mientras se está enviando
  }

  Future<void> flushNow({int attempt = 0}) async {
    if (state || _disposed) return;
    _retry?.cancel();
    state = true;
    try {
      await ref.read(flushOutboxProvider)();
    } finally {
      if (!_disposed) state = false;
    }
    if (_disposed || attempt >= retryDelays.length) return;
    final stillPending = (await ref.read(outboxProvider).pending()).isNotEmpty;
    if (_disposed || !stillPending) return;
    if (!await ref.read(connectivityProvider).isOnline) return;
    _retry = Timer(retryDelays[attempt], () => flushNow(attempt: attempt + 1));
  }
}

final syncControllerProvider = NotifierProvider<SyncController, bool>(
  SyncController.new,
);
