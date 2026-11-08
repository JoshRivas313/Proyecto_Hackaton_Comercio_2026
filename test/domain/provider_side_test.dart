import 'package:flutter_test/flutter_test.dart';
import 'package:red_barrio/core/result.dart';
import 'package:red_barrio/features/directory/domain/provider_side.dart';
import 'package:red_barrio/features/directory/infrastructure/demo_job_board.dart';

import '../fakes/fakes.dart';

class FakeProviderRepo implements ProviderRepository {
  final offers = <ServiceOffer>[];
  final proposals = <String, JobProposal>{};
  @override
  Future<Result<void>> saveOffer(ServiceOffer o) async {
    offers.add(o);
    return const Ok(null);
  }

  @override
  Future<Result<void>> saveProposal(JobProposal p) async {
    proposals[p.jobId] = p;
    return const Ok(null);
  }

  @override
  Stream<List<ServiceOffer>> watchOffers() => Stream.value(offers);
  @override
  Stream<List<JobProposal>> watchProposals() =>
      Stream.value(proposals.values.toList());
}

void main() {
  final repo = FakeProviderRepo();
  final clock = FakeClock(DateTime(2026, 11, 8));

  test('ofrecer un oficio no lleva precio y exige elegir uno válido', () async {
    final uc = PublishServiceOffer(repo: repo, clock: clock, ids: FakeIds());
    expect(await uc(trade: '', availability: 'Hoy'), isA<Err<ServiceOffer>>());
    final ok = await uc(trade: 'Costura', availability: 'Esta semana');
    expect(ok.isOk, isTrue);
    expect(repo.offers.single.trade, 'Costura');
  });

  test('la propuesta NO se envía sin precio (vacío, letras o cero)', () async {
    final uc = SendJobProposal(repo: repo, clock: clock);
    for (final bad in ['', '   ', 'abc', '0']) {
      expect(await uc('job-1', bad), isA<Err<JobProposal>>(), reason: bad);
    }
    expect(repo.proposals, isEmpty);
  });

  test(
    'un precio válido se guarda y reenviar al mismo pedido no duplica',
    () async {
      final uc = SendJobProposal(repo: repo, clock: clock);
      expect((await uc('job-1', 'S/ 35')).isOk, isTrue);
      await uc('job-1', '40');
      expect(repo.proposals.length, 1);
      expect(repo.proposals['job-1']!.priceSoles, 40);
    },
  );

  test('cada oficio recibe 2 pedidos de ejemplo, marcados como ejemplo y con distancia aproximada', () async {
    const board = DemoJobBoard();
    for (final t in offerTrades) {
      final jobs = await board.requestsFor(t);
      expect(jobs.length, 2);
      expect(jobs.every((j) => j.isExample && j.trade == t), isTrue);
    }
  });
}
