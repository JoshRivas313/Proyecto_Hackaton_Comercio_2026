import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import '../../../core/failure.dart';
import '../../../core/result.dart';
import '../domain/provider_side.dart';
import '../../../core/log.dart';

class DriftProviderRepository implements ProviderRepository {
  DriftProviderRepository(this._db);

  final AppDatabase _db;

  @override
  Future<Result<void>> saveOffer(ServiceOffer o) async {
    try {
      await _db
          .into(_db.serviceOffers)
          .insertOnConflictUpdate(
            ServiceOffersCompanion.insert(
              id: o.id,
              trade: o.trade,
              availability: o.availability,
              createdAt: o.createdAt,
            ),
          );
      return const Ok(null);
    } catch (e, st) {
      logError('drift_provider_repository', e, st);
      return const Err(StorageFailure('No se pudo guardar lo que haces.'));
    }
  }

  @override
  Future<Result<void>> deleteOffer(String id) async {
    try {
      await (_db.delete(_db.serviceOffers)..where((t) => t.id.equals(id))).go();
      return const Ok(null);
    } catch (e, st) {
      logError('drift_provider_repository', e, st);
      return const Err(StorageFailure('No se pudo quitar esta capacidad.'));
    }
  }

  @override
  Stream<List<ServiceOffer>> watchOffers() {
    final q = _db.select(_db.serviceOffers)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    return q.watch().map(
      (rows) => [
        for (final r in rows)
          ServiceOffer(
            id: r.id,
            trade: r.trade,
            availability: r.availability,
            createdAt: r.createdAt,
          ),
      ],
    );
  }

  @override
  Future<Result<void>> saveProposal(JobProposal p) async {
    try {
      await _db
          .into(_db.jobProposals)
          .insertOnConflictUpdate(
            JobProposalsCompanion.insert(
              jobId: p.jobId,
              priceSoles: p.priceSoles,
              sentAt: p.sentAt,
            ),
          );
      return const Ok(null);
    } catch (e, st) {
      logError('drift_provider_repository', e, st);
      return const Err(StorageFailure('No se pudo guardar tu propuesta.'));
    }
  }

  @override
  Stream<List<JobProposal>> watchProposals() => _db
      .select(_db.jobProposals)
      .watch()
      .map(
        (rows) => [
          for (final r in rows)
            JobProposal(
              jobId: r.jobId,
              priceSoles: r.priceSoles,
              sentAt: r.sentAt,
            ),
        ],
      );
}
