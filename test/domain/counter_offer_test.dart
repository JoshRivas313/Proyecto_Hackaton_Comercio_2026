import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_barrio/core/db/app_database.dart';
import 'package:red_barrio/core/result.dart';
import 'package:red_barrio/features/proposals/domain/deal.dart';
import 'package:red_barrio/features/proposals/domain/price_change.dart';
import 'package:red_barrio/features/proposals/infrastructure/drift_deal_repository.dart';
import 'package:red_barrio/features/proposals/infrastructure/drift_price_change_repository.dart';
import 'package:red_barrio/features/reputation/domain/interaction.dart';
import 'package:red_barrio/features/reputation/domain/rate_participant.dart';

import '../fakes/fakes.dart';

class FakeChanges implements PriceChangeRepository {
  FakeChanges(this.deals);
  final FakeDeals deals;
  final Map<String, PriceChange> store = {};

  @override
  Future<Result<void>> save(PriceChange c) async {
    await Future<void>.delayed(Duration.zero);
    store[c.id] = c;
    return const Ok(null);
  }

  @override
  Future<Result<void>> saveAccepted(Deal d, PriceChange c) async {
    deals.store[d.id] = d;
    store[c.id] = c;
    return const Ok(null);
  }

  @override
  Future<List<PriceChange>> forDeal(String dealId) async =>
      store.values.where((c) => c.dealId == dealId).toList();

  @override
  Stream<List<PriceChange>> watchAll() => Stream.value(store.values.toList());
}

Deal _deal({DealStatus status = DealStatus.inProgress, int price = 40}) => Deal(
  id: 'd1',
  needId: 'n1',
  providerId: 'prov',
  providerName: 'Prestador',
  priceSoles: price,
  priceLabel: 'S/ $price',
  code: '1234',
  status: status,
  acceptedAt: DateTime(2026, 11, 8, 9),
  startedAt: DateTime(2026, 11, 8, 9, 30),
);

void main() {
  late FakeDeals deals;
  late FakeChanges changes;
  late CounterOfferService svc;

  setUp(() {
    deals = FakeDeals();
    changes = FakeChanges(deals);
    svc = CounterOfferService(
      deals: deals,
      changes: changes,
      clock: FakeClock(DateTime(2026, 11, 8, 10)),
      ids: FakeIds(),
    );
  });

  Future<Result<PriceChange>> propose(
    int price, {
    String reason = 'Es más trabajo',
  }) => svc.propose('d1', by: 'prov', newPrice: price, reason: reason);

  group('cuándo se puede contraofertar', () {
    test('antes del encuentro (código sin validar): rechazada', () async {
      deals.store['d1'] = _deal(status: DealStatus.accepted);
      expect(await propose(50), isA<Err<dynamic>>());
      expect(changes.store, isEmpty);
    });

    test('solo el prestador seleccionado puede iniciarla', () async {
      deals.store['d1'] = _deal();
      final r = await svc.propose(
        'd1',
        by: 'me',
        newPrice: 50,
        reason: 'Más trabajo',
      );
      expect(r, isA<Err<dynamic>>());
      final other = await svc.propose(
        'd1',
        by: 'otro',
        newPrice: 50,
        reason: 'Más trabajo',
      );
      expect(other, isA<Err<dynamic>>());
    });

    test('exige monto nuevo y motivo', () async {
      deals.store['d1'] = _deal();
      expect(await propose(40), isA<Err<dynamic>>()); // mismo monto
      expect(await propose(0), isA<Err<dynamic>>());
      expect(await propose(50, reason: ''), isA<Err<dynamic>>());
    });

    test('favores, préstamos y donaciones (precio 0) no se negocian', () async {
      deals.store['d1'] = _deal(price: 0);
      expect(await propose(10), isA<Err<dynamic>>());
    });
  });

  group('máximo de 2 contraofertas por trato', () {
    test(
      'la primera y la segunda se permiten; la tercera se bloquea',
      () async {
        deals.store['d1'] = _deal();
        final first = await propose(50);
        expect(first.isOk, isTrue);
        await svc.respond(
          'd1',
          (first as Ok<PriceChange>).value.id,
          accept: false,
        );
        final second = await propose(45);
        expect(second.isOk, isTrue);
        await svc.respond(
          'd1',
          (second as Ok<PriceChange>).value.id,
          accept: false,
        );
        expect(await svc.remaining('d1'), 0);
        expect(await propose(44), isA<Err<dynamic>>());
        expect(changes.store.length, 2);
      },
    );

    test('no se permite otra mientras haya una pendiente', () async {
      deals.store['d1'] = _deal();
      await propose(50);
      expect(await propose(55), isA<Err<dynamic>>());
    });

    test('dos contraofertas simultáneas: solo una queda guardada', () async {
      deals.store['d1'] = _deal();
      final results = await Future.wait([propose(50), propose(55)]);
      expect(results.whereType<Ok<dynamic>>().length, 1);
      expect(changes.store.length, 1);
    });
  });

  group('aceptar y rechazar', () {
    test(
      'la contraoferta no cambia el precio hasta que el cliente la acepta',
      () async {
        deals.store['d1'] = _deal();
        final c = (await propose(50) as Ok<PriceChange>).value;
        expect(deals.store['d1']!.priceSoles, 40);
        final r = await svc.respond('d1', c.id, accept: true);
        expect(r.isOk, isTrue);
        expect(deals.store['d1']!.priceSoles, 50);
        expect(deals.store['d1']!.priceLabel, 'S/ 50');
      },
    );

    test('al rechazar el precio vigente se conserva', () async {
      deals.store['d1'] = _deal();
      final c = (await propose(50) as Ok<PriceChange>).value;
      await svc.respond('d1', c.id, accept: false);
      expect(deals.store['d1']!.priceSoles, 40);
      expect(changes.store[c.id]!.status, PriceChangeStatus.rejected);
    });

    test('no se acepta una contraoferta obsoleta ni dos veces', () async {
      deals.store['d1'] = _deal();
      final c = (await propose(50) as Ok<PriceChange>).value;
      expect((await svc.respond('d1', c.id, accept: true)).isOk, isTrue);
      // La misma contraoferta ya no está vigente.
      expect(await svc.respond('d1', c.id, accept: true), isA<Err<dynamic>>());
      expect(
        await svc.respond('d1', 'inventada', accept: true),
        isA<Err<dynamic>>(),
      );
      expect(deals.store['d1']!.priceSoles, 50);
    });

    test(
      'el historial conserva precio anterior, nuevo, motivo, autor y fecha',
      () async {
        deals.store['d1'] = _deal();
        final c = (await propose(
          50,
          reason: 'Hay que cambiar la tubería',
        ) as Ok<PriceChange>).value;
        expect(c.previousPrice, 40);
        expect(c.newPrice, 50);
        expect(c.reason, 'Hay que cambiar la tubería');
        expect(c.author, 'provider');
        expect(c.createdAt, DateTime(2026, 11, 8, 10));
      },
    );
  });

  group('cancelación', () {
    test('se registra el motivo y no hay penalidad automática', () async {
      deals.store['d1'] = _deal();
      final r = await CancelDeal(
        deals: deals,
        clock: FakeClock(DateTime(2026, 11, 8, 11)),
      )('d1', reason: 'No hubo acuerdo de precio');
      expect(r.isOk, isTrue);
      final d = deals.store['d1']!;
      expect(d.status, DealStatus.cancelled);
      expect(d.cancelReason, 'No hubo acuerdo de precio');
    });

    test('exige motivo', () async {
      deals.store['d1'] = _deal();
      final r = await CancelDeal(
        deals: deals,
        clock: FakeClock(DateTime(2026)),
      )('d1', reason: '');
      expect(r, isA<Err<dynamic>>());
    });
  });

  test(
    'el contador persiste: no se reinicia al reabrir (base de datos real)',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final dealRepo = DriftDealRepository(db);
      final changeRepo = DriftPriceChangeRepository(db);
      await dealRepo.save(_deal());
      final ids =
          FakeIds(); // los ids reales son UUID únicos: se comparte el generador
      CounterOfferService build() => CounterOfferService(
        deals: dealRepo,
        changes: changeRepo,
        clock: FakeClock(DateTime(2026, 11, 8, 10)),
        ids: ids,
      );

      final first = build();
      final c1 = (await first.propose(
        'd1',
        by: 'prov',
        newPrice: 50,
        reason: 'Más trabajo',
      )) as Ok<PriceChange>;
      await first.respond('d1', c1.value.id, accept: false);

      // "Cerrar y reabrir la app": un servicio nuevo sobre la misma base.
      final reopened = build();
      expect(await reopened.remaining('d1'), 1);
      final c2 = (await reopened.propose(
        'd1',
        by: 'prov',
        newPrice: 45,
        reason: 'Materiales',
      )) as Ok<PriceChange>;
      await reopened.respond('d1', c2.value.id, accept: false);
      expect(await build().remaining('d1'), 0);
      expect(
        await build().propose(
          'd1',
          by: 'prov',
          newPrice: 44,
          reason: 'Otra vez',
        ),
        isA<Err<dynamic>>(),
      );
    },
  );

  group('calificación bidireccional', () {
    late FakeReputation rep;
    late RateParticipant rate;

    setUp(() {
      rep = FakeReputation();
      rate = RateParticipant(
        deals: deals,
        reputation: rep,
        clock: FakeClock(DateTime(2026, 11, 8, 12)),
        ids: FakeIds(),
      );
      deals.store['d1'] = _deal(status: DealStatus.awaitingRating);
    });

    test(
      'el cliente califica al prestador y el prestador al cliente',
      () async {
        final a = await rate(
          'd1',
          raterId: clientId,
          about: RatedRole.provider,
          stars: 5,
          recommend: true,
        );
        final b = await rate(
          'd1',
          raterId: 'prov',
          about: RatedRole.client,
          stars: 4,
        );
        expect(a.isOk, isTrue);
        expect(b.isOk, isTrue);
        expect(rep.store.length, 2);
      },
    );

    test('solo una evaluación por participante y trato', () async {
      await rate('d1', raterId: clientId, about: RatedRole.provider, stars: 5);
      expect(
        await rate(
          'd1',
          raterId: clientId,
          about: RatedRole.provider,
          stars: 1,
        ),
        isA<Err<dynamic>>(),
      );
      await rate('d1', raterId: 'prov', about: RatedRole.client, stars: 4);
      expect(
        await rate('d1', raterId: 'prov', about: RatedRole.client, stars: 2),
        isA<Err<dynamic>>(),
      );
      expect(rep.store.length, 2);
    });

    test('no hay autoevaluaciones ni se califica en nombre del otro', () async {
      expect(
        await rate('d1', raterId: 'prov', about: RatedRole.provider, stars: 5),
        isA<Err<dynamic>>(),
      );
      expect(
        await rate('d1', raterId: clientId, about: RatedRole.client, stars: 5),
        isA<Err<dynamic>>(),
      );
    });

    test('las evaluaciones son independientes: calificar al cliente no exige lo otro', () async {
      final only = await rate(
        'd1',
        raterId: 'prov',
        about: RatedRole.client,
        stars: 3,
      );
      expect(only.isOk, isTrue);
      // La valoración como cliente no cuenta para la reputación como prestador.
      expect(await rep.forProvider('prov'), isEmpty);
    });

    test(
      'el cliente no recibe recomendaciones (Visto Bueno es del prestador)',
      () async {
        final r = await rate(
          'd1',
          raterId: 'prov',
          about: RatedRole.client,
          stars: 5,
          recommend: true,
        );
        expect((r as Ok<Interaction>).value.recommended, isFalse);
      },
    );

    test('no se califica un servicio que no terminó', () async {
      deals.store['d1'] = _deal(status: DealStatus.inProgress);
      expect(
        await rate(
          'd1',
          raterId: clientId,
          about: RatedRole.provider,
          stars: 5,
        ),
        isA<Err<dynamic>>(),
      );
    });

    test('se puede cerrar el trato sin calificar', () async {
      final r = await CloseWithoutRating(deals: deals)('d1');
      expect(r.isOk, isTrue);
      expect(deals.store['d1']!.status, DealStatus.closed);
      expect(rep.store, isEmpty);
    });
  });
}
