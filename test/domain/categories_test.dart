import 'package:flutter_test/flutter_test.dart';
import 'package:red_barrio/core/result.dart';
import 'package:red_barrio/features/directory/domain/provider_side.dart';
import 'package:red_barrio/features/directory/domain/trades.dart';
import 'package:red_barrio/features/needs/domain/need.dart';
import 'package:red_barrio/features/needs/domain/usecases/publish_need.dart';

import '../fakes/fakes.dart';
import 'provider_side_test.dart' show FakeProviderRepo;

void main() {
  test('catálogo: ids únicos y los filtros salen del mismo catálogo', () {
    final ids = tradeCategories.map((c) => c.id).toSet();
    expect(ids.length, tradeCategories.length);
    expect(serviceTrades.first, 'Todos');
    expect(serviceTrades.skip(1), tradeCategories.map((c) => c.label));
  });

  test('se encuentra la categoría por id, rubro u oficio', () {
    expect(tradeById('gasfiteria')?.label, 'Gasfitería');
    expect(tradeByName('Gasfitero')?.id, 'gasfiteria');
    expect(tradeByName('Electricidad')?.id, 'electricidad');
    expect(tradeById('inventada'), isNull);
    expect(tradeById(null), isNull);
  });

  test(
    'la categoría elegida queda guardada en la solicitud y en la cola',
    () async {
      final needs = FakeNeeds();
      final outbox = FakeOutbox();
      final publish = PublishNeed(
        needs: needs,
        outbox: outbox,
        clock: FakeClock(DateTime(2026, 11, 8)),
        ids: FakeIds(),
      );
      final r = await publish(
        kind: NeedKind.service,
        text: 'Necesito un gasfitero para arreglar una fuga',
        categoryId: 'gasfiteria',
      );
      expect(r.isOk, isTrue);
      final saved = (r as Ok<Need>).value;
      expect(saved.categoryId, 'gasfiteria');
      expect(
        outbox.ops.values.single.payload,
        contains('"category":"gasfiteria"'),
      );
    },
  );

  test('una capacidad se puede quitar y las demás se conservan', () async {
    final repo = FakeProviderRepo();
    final now = DateTime(2026, 11, 8);
    await repo.saveOffer(
      ServiceOffer(
        id: 'a',
        trade: 'Gasfitería',
        availability: 'Hoy',
        createdAt: now,
      ),
    );
    await repo.saveOffer(
      ServiceOffer(
        id: 'b',
        trade: 'Clases',
        availability: 'Tardes',
        createdAt: now,
      ),
    );
    await repo.deleteOffer('a');
    expect(repo.offers.map((o) => o.id), ['b']);
  });
}
