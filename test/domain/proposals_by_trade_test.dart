import 'package:flutter_test/flutter_test.dart';
import 'package:red_barrio/features/needs/domain/need.dart';
import 'package:red_barrio/features/proposals/infrastructure/demo_proposal_repository.dart';

void main() {
  const repo = DemoProposalRepository();

  Need need(String text, {NeedKind kind = NeedKind.service}) => Need(
    id: 'n',
    kind: kind,
    text: text,
    urgency: Urgency.today,
    createdAt: DateTime(2026, 11, 8),
    syncStatus: SyncStatus.sent,
  );

  Future<List<String>> ids(String text) async =>
      (await repo.forNeed(need(text))).map((p) => p.providerId).toList();

  test(
    'un pedido de electricista recibe electricistas, no gasfiteros',
    () async {
      expect(
        await ids('Necesito un electricista, se fue la luz en la cocina'),
        ['pedro'],
      );
    },
  );

  test('gasfitería devuelve los 3 gasfiteros', () async {
    expect(await ids('Necesito un gasfitero para arreglar una fuga'), [
      'carlos',
      'maria',
      'jose',
    ]);
  });

  test('"perdí mis llaves" es cerrajería y no gasfitería', () async {
    expect(await ids('Necesito un cerrajero, perdí mis llaves'), ['victor']);
    expect(await ids('PERDÍ MIS LLAVES'), ['victor']);
  });

  test('reconoce otros oficios ignorando mayúsculas y tildes', () async {
    expect(await ids('Necesito arreglar un pantalón'), ['rosam']);
    expect(await ids('Necesito clases de matemática para mi hijo'), ['andrea']);
    expect(await ids('Necesito que alguien pasee a mi perro'), ['lucia']);
    expect(await ids('Necesito un carpintero para arreglar un mueble'), [
      'hugo',
    ]);
  });

  test('un oficio no reconocido NO inventa propuestas', () async {
    expect(await ids('Necesito pintar las paredes de mi sala'), isEmpty);
  });

  test(
    'productos, préstamos y ayudas siguen con 3 propuestas de ejemplo',
    () async {
      for (final k in [NeedKind.product, NeedKind.loan, NeedKind.help]) {
        expect((await repo.forNeed(need('cualquier cosa', kind: k))).length, 3);
      }
    },
  );

  test('todas las propuestas se marcan como ejemplo', () async {
    final all = await repo.forNeed(need('Necesito un electricista'));
    expect(all.every((p) => p.isExample), isTrue);
  });
}
