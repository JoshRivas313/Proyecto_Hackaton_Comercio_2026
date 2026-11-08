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

Proposal _p(String id, int price) => Proposal(
  providerId: id,
  providerName: 'Prestador $id',
  role: 'Gasfitero',
  priceSoles: price,
  priceLabel: 'S/ $price',
  distanceMeters: 300,
  availability: 'Hoy',
  etaHours: 1,
  isExample: false,
);

Need _need() => Need(
  id: 'n1',
  kind: NeedKind.service,
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
    neg = Negotiate(repo: repo, accept: accept, clock: clock, ids: ids);
  });

  group('una sola propuesta aceptada por pedido', () {
    test('dos aceptaciones simultáneas no generan dos tratos', () async {
      final results = await Future.wait([
        accept(_need(), _p('a', 40)),
        accept(_need(), _p('b', 35)),
      ]);
      expect(results.whereType<Ok<dynamic>>().length, 1);
      expect(results.whereType<Err<dynamic>>().length, 1);
      expect(deals.store.length, 1);
    });

    test('con un trato en curso no se acepta otra propuesta', () async {
      await neg.acceptOffer(_need(), _p('a', 40));
      expect(await neg.acceptOffer(_need(), _p('b', 35)), isA<Err<dynamic>>());
      expect(deals.store.length, 1);
    });

    test(
      'las propuestas no elegidas quedan en el historial como descartadas',
      () async {
        final r = await neg.acceptOffer(
          _need(),
          _p('a', 40),
          others: [_p('a', 40), _p('b', 35), _p('c', 50)],
        );
        expect(r.isOk, isTrue);
        final all = await repo.forNeed('n1');
        expect(all.where((v) => v.status == OfferStatus.accepted).length, 1);
        expect(
          all
              .where((v) => v.status == OfferStatus.discarded)
              .map((v) => v.providerId),
          unorderedEquals(['b', 'c']),
        );
      },
    );

    test(
      'el trato se acepta al precio de la propuesta, sin contraoferta',
      () async {
        await neg.acceptOffer(_need(), _p('a', 40));
        expect(deals.store.values.single.priceSoles, 40);
      },
    );
  });

  test('rechazar deja la propuesta en el historial como rechazada', () async {
    expect((await neg.reject(_need(), _p('a', 40))).isOk, isTrue);
    final all = await repo.forNeed('n1');
    expect(all.single.status, OfferStatus.rejected);
    expect(deals.store, isEmpty);
  });
}
