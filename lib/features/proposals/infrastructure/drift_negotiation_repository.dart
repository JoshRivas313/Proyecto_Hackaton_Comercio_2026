import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import '../../../core/failure.dart';
import '../../../core/result.dart';
import '../domain/negotiation.dart';
import '../../../core/log.dart';

class DriftNegotiationRepository implements NegotiationRepository {
  DriftNegotiationRepository(this._db);

  final AppDatabase _db;

  @override
  Future<Result<void>> saveAll(List<OfferVersion> versions) async {
    try {
      await _db.transaction(() async {
        for (final v in versions) {
          await _db
              .into(_db.negotiationOffers)
              .insertOnConflictUpdate(
                NegotiationOffersCompanion.insert(
                  id: v.id,
                  needId: v.needId,
                  providerId: v.providerId,
                  byClient: v.by == OfferParty.client,
                  priceSoles: v.priceSoles,
                  priceLabel: v.priceLabel,
                  conditions: Value(v.conditions),
                  status: v.status.name,
                  createdAt: v.createdAt,
                ),
              );
        }
      });
      return const Ok(null);
    } catch (e, st) {
      logError('drift_negotiation_repository', e, st);
      return const Err(StorageFailure('No se pudo guardar la negociación.'));
    }
  }

  OfferVersion _toDomain(OfferVersionRow r) => OfferVersion(
    id: r.id,
    needId: r.needId,
    providerId: r.providerId,
    by: r.byClient ? OfferParty.client : OfferParty.provider,
    priceSoles: r.priceSoles,
    priceLabel: r.priceLabel,
    conditions: r.conditions,
    status: OfferStatus.values.byName(r.status),
    createdAt: r.createdAt,
  );

  @override
  Future<List<OfferVersion>> forNeed(String needId) async {
    final rows =
        await (_db.select(_db.negotiationOffers)
              ..where((t) => t.needId.equals(needId))
              ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
            .get();
    return rows.map(_toDomain).toList();
  }

  @override
  Stream<List<OfferVersion>> watchAll() =>
      (_db.select(_db.negotiationOffers)
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .watch()
          .map((rows) => rows.map(_toDomain).toList());
}
