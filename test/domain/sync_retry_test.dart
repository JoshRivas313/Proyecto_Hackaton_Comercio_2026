import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_barrio/app/di/providers.dart';
import 'package:red_barrio/core/failure.dart';
import 'package:red_barrio/core/result.dart';
import 'package:red_barrio/features/sync/domain/outbox_queue.dart';
import 'package:red_barrio/features/sync/domain/sync_gateway.dart';
import 'package:red_barrio/features/sync/domain/usecases/flush_outbox.dart';
import 'package:red_barrio/features/sync/presentation/sync_controller.dart';

import '../fakes/fakes.dart';

/// Falla las primeras [failures] veces (la red avisa «hay internet» antes de estar lista).
class _FlakyGateway implements SyncGateway {
  _FlakyGateway(this.failures);
  int failures;
  int calls = 0;
  final List<String> received = [];

  @override
  bool get isDemo => false;

  @override
  Future<Result<void>> send(OutboxOp op) async {
    calls++;
    if (failures > 0) {
      failures--;
      return const Err(NetworkFailure('la red aún no responde'));
    }
    received.add(op.id);
    return const Ok(null);
  }
}

void main() {
  late FakeOutbox outbox;
  late _FlakyGateway gateway;
  late ProviderContainer container;

  ProviderContainer build(_FlakyGateway g) {
    final net = FakeConnectivity();
    return ProviderContainer(
      overrides: [
        outboxProvider.overrideWithValue(outbox),
        connectivityProvider.overrideWithValue(net),
        flushOutboxProvider.overrideWithValue(
          FlushOutbox(
            outbox: outbox,
            gateway: g,
            connectivity: net,
            needs: FakeNeeds(),
          ),
        ),
      ],
    );
  }

  setUp(() {
    SyncController.retryDelays = const [
      Duration(milliseconds: 20),
      Duration(milliseconds: 20),
      Duration(milliseconds: 20),
    ];
    outbox = FakeOutbox();
    outbox.ops['n1'] = OutboxOp(
      id: 'n1',
      type: 'publish_need',
      payload: '{}',
      createdAt: DateTime(2026, 11, 8),
    );
  });

  tearDown(() => container.dispose());

  test(
    'si el primer intento falla, reintenta solo y termina enviando',
    () async {
      gateway = _FlakyGateway(2);
      container = build(gateway);
      container.read(syncControllerProvider);
      await Future<void>.delayed(const Duration(milliseconds: 400));
      expect(gateway.received, ['n1']);
      expect(outbox.ops, isEmpty);
      expect(gateway.calls, 3);
    },
  );

  test(
    'no reintenta para siempre: se detiene tras los intentos permitidos',
    () async {
      gateway = _FlakyGateway(1000);
      container = build(gateway);
      container.read(syncControllerProvider);
      await Future<void>.delayed(const Duration(milliseconds: 400));
      // 1 intento inicial + 3 reintentos, y la operación sigue pendiente (no se pierde).
      expect(gateway.calls, 4);
      expect(outbox.ops.keys, ['n1']);
    },
  );
}
