import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:red_barrio/core/failure.dart';
import 'package:red_barrio/core/result.dart';
import 'package:red_barrio/features/sync/domain/outbox_queue.dart';
import 'package:red_barrio/features/sync/infrastructure/remote_store.dart';
import 'package:red_barrio/features/sync/infrastructure/supabase_sync_gateway.dart';

class _FakeStore implements RemoteStore {
  Result<void> session = const Ok(null);
  Result<void> insertResult = const Ok(null);
  final List<(String, Map<String, Object?>)> inserted = [];

  @override
  Future<Result<void>> ensureSession() async => session;

  @override
  Future<Result<void>> insert(String table, Map<String, Object?> row) async {
    if (insertResult case Err()) return insertResult;
    inserted.add((table, row));
    return const Ok(null);
  }
}

OutboxOp _op(String type, Map<String, Object?> payload, {String id = 'id-1'}) =>
    OutboxOp(
      id: id,
      type: type,
      payload: jsonEncode(payload),
      createdAt: DateTime(2026, 11, 8),
    );

void main() {
  late _FakeStore store;
  late SupabaseSyncGateway gateway;

  setUp(() {
    store = _FakeStore();
    gateway = SupabaseSyncGateway(store);
  });

  test(
    'no es demostración: la pantalla puede decir «Enviada» solo tras confirmar',
    () {
      expect(gateway.isDemo, isFalse);
    },
  );

  test(
    'un pedido se envía a `needs` con el UUID del cliente y SIN ubicación',
    () async {
      final r = await gateway.send(
        _op('publish_need', {
          'kind': 'service',
          'text': 'Necesito un gasfitero',
          'urgency': 'today',
          'details': 'Fuga en la cocina',
          'category': 'gasfiteria',
        }),
      );
      expect(r, isA<Ok<void>>());
      final (table, row) = store.inserted.single;
      expect(table, 'needs');
      expect(row['id'], 'id-1');
      expect(row['body'], 'Necesito un gasfitero');
      expect(row['category_id'], 'gasfiteria');
      // Regla 3: la ubicación no sale del teléfono por este camino.
      expect(row.containsKey('zone'), isFalse);
      expect(row.containsKey('location'), isFalse);
    },
  );

  test('una emergencia no sensible se envía a `emergency_posts`', () async {
    final r = await gateway.send(
      _op('sos', {
        'type': 'fire',
        'why': 'Hay un incendio cerca',
        'needs': ['Agua'],
      }),
    );
    expect(r, isA<Ok<void>>());
    expect(store.inserted.single.$1, 'emergency_posts');
    expect(store.inserted.single.$2['needs'], ['Agua']);
  });

  test('sin sesión o sin internet NO se envía y devuelve el error', () async {
    store.session = const Err(NetworkFailure('sin internet'));
    final r = await gateway.send(
      _op('publish_need', {
        'kind': 'help',
        'text': 'Necesito ayuda',
        'urgency': 'now',
      }),
    );
    expect(r, isA<Err<void>>());
    expect(store.inserted, isEmpty);
  });

  test('si el servidor rechaza, no se marca como enviada', () async {
    store.insertResult = const Err(UnknownFailure('falló'));
    final r = await gateway.send(
      _op('publish_need', {
        'kind': 'help',
        'text': 'Necesito ayuda',
        'urgency': 'now',
      }),
    );
    expect(r, isA<Err<void>>());
  });

  test(
    'texto más largo que lo que acepta el servidor se rechaza antes de enviar',
    () async {
      final r = await gateway.send(
        _op('publish_need', {
          'kind': 'help',
          'text': 'a' * (SupabaseSyncGateway.maxBody + 1),
          'urgency': 'now',
        }),
      );
      expect(r, isA<Err<void>>());
      expect(store.inserted, isEmpty);
    },
  );

  test(
    'operaciones desconocidas o dañadas fallan sin tocar el servidor',
    () async {
      expect(await gateway.send(_op('otra_cosa', {})), isA<Err<void>>());
      final broken = OutboxOp(
        id: 'x',
        type: 'publish_need',
        payload: '{no es json',
        createdAt: DateTime(2026, 11, 8),
      );
      expect(await gateway.send(broken), isA<Err<void>>());
      expect(store.inserted, isEmpty);
    },
  );
}
