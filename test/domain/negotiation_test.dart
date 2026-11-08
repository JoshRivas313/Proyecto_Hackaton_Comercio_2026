import 'package:flutter_test/flutter_test.dart';
import 'package:red_barrio/core/result.dart';
import 'package:red_barrio/features/needs/domain/need.dart';
import 'package:red_barrio/features/proposals/domain/negotiation.dart';
import 'package:red_barrio/features/proposals/domain/proposal.dart';
import 'package:red_barrio/features/proposals/domain/usecases/deal_usecases.dart';
import 'package:red_barrio/features/proposals/domain/usecases/negotiate.dart';

import '../fakes/fakes.dart';

class FakeNegotiations implements NegotiationRepository {
  final Map<String, OfferVersion> store = {};

  @override
  Future<Result<void>> saveAll(List<OfferVersion> versions) async {
    for (final v in versions) {
      store[v.id] = v;
    }
    return const Ok(null);
  }

  @override
  Future<List<OfferVersion>> forNeed(String needId) async =>
      store.values.where((v) => v.needId == needId).toList();

  @override
  Stream<List<OfferVersion>> watchAll() => Stream.value(store.values.toList());
}

Proposal _p(String id, int price, {String? label}) => Proposal(
  providerId: id,
  providerName: 'Prestador $id',
  role: 'Gasfitero',
  priceSoles: price,
  priceLabel: label ?? 'S/ $price',
  distanceMeters: 300,
  availability: 'Hoy',
  etaHours: 1,
  isExample: false,
);

Need _need(NeedKind kind) => Need(
  id: 'n1',
  kind: kind,
  text: 'Necesito algo',
  urgency: Urgency.today,
  createdAt: DateTime(2026, 11, 8),
  syncStatus: SyncStatus.sent,
);

void main() {
  late FakeDeals deals;
  late FakeNegotiations repo;
  late AcceptProposal accept;
  late Negotiate neg;

  setUp(() {
    deals = FakeDeals();
    repo = FakeNegotiations();
    final clock = FakeClock(DateTime(2026, 11, 8, 10));
    final ids = FakeIds();
    accept = AcceptProposal(deals: deals, clock: clock, ids: ids);
    neg = Negotiate(
      repo: repo,
      deals: deals,
      accept: accept,
      clock: clock,
      ids: ids,
    );
  });

  group('una sola propuesta aceptada por pedido', () {
    test('dos aceptaciones simultáneas no generan dos tratos', () async {
      final need = _need(NeedKind.service);
      final results = await Future.wait([
        accept(need, _p('a', 40)),
        accept(need, _p('b', 35)),
      ]);
      expect(results.whereType<Ok<dynamic>>().length, 1);
      expect(results.whereType<Err<dynamic>>().length, 1);
      expect(deals.store.length, 1);
    });

    test(
      'con un trato en curso no se acepta ni se contraoferta otra propuesta',
      () async {
        final need = _need(NeedKind.service);
        await neg.acceptOffer(need, _p('a', 40), by: OfferParty.client);
        expect(
          await neg.acceptOffer(need, _p('b', 35), by: OfferParty.client),
          isA<Err<dynamic>>(),
        );
        expect(
          await neg.counter(
            need,
            _p('b', 35),
            by: OfferParty.client,
            priceSoles: 30,
          ),
          isA<Err<dynamic>>(),
        );
        expect(deals.store.length, 1);
      },
    );

    test(
      'las propuestas no elegidas quedan en el historial como descartadas',
      () async {
        final need = _need(NeedKind.service);
        await neg.counter(
          need,
          _p('b', 35),
          by: OfferParty.client,
          priceSoles: 30,
        );
        final r = await neg.acceptOffer(
          need,
          _p('a', 40),
          by: OfferParty.client,
        );
        expect(r.isOk, isTrue);
        final all = await repo.forNeed(need.id);
        expect(
          all.firstWhere((v) => v.providerId == 'b').status,
          OfferStatus.discarded,
        );
        expect(
          all.firstWhere((v) => v.providerId == 'a').status,
          OfferStatus.accepted,
        );
      },
    );
  });

  group('contraofertas', () {
    test('el cliente contraoferta y solo queda una versión vigente', () async {
      final need = _need(NeedKind.service);
      final p = _p('a', 40);
      await neg.counter(need, p, by: OfferParty.client, priceSoles: 30);
      // El prestador responde con otra contraoferta: la anterior pasa a "countered".
      await neg.counter(need, p, by: OfferParty.provider, priceSoles: 35);
      final all = await repo.forNeed(need.id);
      expect(all.length, 2);
      expect(all.where((v) => v.status == OfferStatus.pending).length, 1);
      expect(currentOffer(all, 'a')?.priceSoles, 35);
      expect(all.first.status, OfferStatus.countered);
    });

    test(
      'no se puede contraofertar dos veces seguidas ni aceptar lo propio',
      () async {
        final need = _need(NeedKind.service);
        final p = _p('a', 40);
        await neg.counter(need, p, by: OfferParty.client, priceSoles: 30);
        expect(
          await neg.counter(need, p, by: OfferParty.client, priceSoles: 28),
          isA<Err<dynamic>>(),
        );
        expect(
          await neg.acceptOffer(need, p, by: OfferParty.client),
          isA<Err<dynamic>>(),
        );
      },
    );

    test(
      'al aceptar la contraoferta el trato queda con el precio acordado',
      () async {
        final need = _need(NeedKind.service);
        final p = _p('a', 40);
        await neg.counter(need, p, by: OfferParty.client, priceSoles: 30);
        final r = await neg.acceptOffer(need, p, by: OfferParty.provider);
        expect(r.isOk, isTrue);
        expect(deals.store.values.single.priceSoles, 30);
        final all = await repo.forNeed(need.id);
        expect(all.single.status, OfferStatus.accepted);
      },
    );

    test('rechazar deja la propuesta en el historial como rechazada', () async {
      final need = _need(NeedKind.service);
      final p = _p('a', 40);
      expect((await neg.reject(need, p, by: OfferParty.client)).isOk, isTrue);
      final all = await repo.forNeed(need.id);
      expect(all.single.status, OfferStatus.rejected);
      expect(deals.store, isEmpty);
    });

    test('préstamos, favores y donaciones no se negocian por precio', () async {
      final need = _need(NeedKind.loan);
      final p = _p('a', 0, label: 'Préstamo gratis');
      expect(
        await neg.counter(need, p, by: OfferParty.client, priceSoles: 10),
        isA<Err<dynamic>>(),
      );
      // Pero sí se puede aceptar tal cual.
      expect(
        (await neg.acceptOffer(need, p, by: OfferParty.client)).isOk,
        isTrue,
      );
    });
  });
}
