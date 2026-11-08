import 'package:flutter_test/flutter_test.dart';
import 'package:red_barrio/core/result.dart';
import 'package:red_barrio/features/emergency/domain/emergency.dart';
import 'package:red_barrio/features/emergency/domain/usecases/publish_sos.dart';
import 'package:red_barrio/features/needs/domain/need.dart';
import 'package:red_barrio/features/sync/domain/usecases/flush_outbox.dart';

import '../fakes/fakes.dart';

class FakeEmergency implements EmergencyRepository {
  final Map<String, EmergencyPost> store = {};
  @override
  Future<Result<void>> save(EmergencyPost post) async {
    store[post.id] = post;
    return const Ok(null);
  }

  @override
  Future<Result<void>> updateStatus(String id, SyncStatus status) async {
    final p = store[id];
    if (p != null) {
      store[id] = EmergencyPost(
        id: p.id,
        type: p.type,
        why: p.why,
        needs: p.needs,
        createdAt: p.createdAt,
        syncStatus: status,
      );
    }
    return const Ok(null);
  }

  @override
  Stream<List<EmergencyPost>> watchAll() => Stream.value(store.values.toList());
}

void main() {
  late FakeEmergency posts;
  late FakeOutbox outbox;
  late FakeGateway gateway;
  late FakeConnectivity net;
  late PublishSos sos;
  late FlushOutbox flush;

  setUp(() {
    posts = FakeEmergency();
    outbox = FakeOutbox();
    gateway = FakeGateway();
    net = FakeConnectivity();
    sos = PublishSos(
      posts: posts,
      outbox: outbox,
      clock: FakeClock(DateTime(2026, 11, 8)),
      ids: FakeIds(),
    );
    flush = FlushOutbox(
      outbox: outbox,
      gateway: gateway,
      connectivity: net,
      needs: FakeNeeds(),
      emergency: posts,
    );
  });

  test(
    'cada situación tiene institución oficial y plantilla de "qué pasó"',
    () {
      for (final t in EmergencyType.values) {
        expect(t.institution, isNotEmpty);
        expect(t.template.length, greaterThan(2));
      }
    },
  );

  test(
    'violencia es privada: se guarda en el teléfono y NO se encola ni se envía',
    () async {
      final r = await sos(type: EmergencyType.violence, why: 'Necesito ayuda');
      expect(r.isOk, isTrue);
      expect(posts.store.length, 1);
      expect(outbox.ops, isEmpty);
      await flush();
      expect(gateway.received, isEmpty);
      expect(posts.store.values.single.syncStatus, SyncStatus.pending);
    },
  );

  test('un SOS normal sin conexión queda Pendiente y al volver la red pasa a Enviado una vez', () async {
    net.online = false;
    await sos(type: EmergencyType.quake, why: 'Hubo un sismo', needs: ['Agua']);
    await flush();
    expect(posts.store.values.single.syncStatus, SyncStatus.pending);
    net.online = true;
    await flush();
    await flush();
    expect(posts.store.values.single.syncStatus, SyncStatus.sent);
    expect(gateway.received.length, 1);
  });

  test('si el envío falla queda en Error y no se marca enviado', () async {
    await sos(type: EmergencyType.fire, why: 'Hay un incendio');
    gateway.failNext = true;
    await flush();
    expect(posts.store.values.single.syncStatus, SyncStatus.error);
  });

  test('texto vacío se rechaza y no guarda nada', () async {
    final r = await sos(type: EmergencyType.medical, why: ' ');
    expect(r, isA<Err<EmergencyPost>>());
    expect(posts.store, isEmpty);
  });
}
