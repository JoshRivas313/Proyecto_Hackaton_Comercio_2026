import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import '../../../core/failure.dart';
import '../../../core/result.dart';
import '../../needs/domain/need.dart';
import '../domain/emergency.dart';
import '../../../core/log.dart';

class DriftEmergencyRepository implements EmergencyRepository {
  DriftEmergencyRepository(this._db);

  final AppDatabase _db;

  @override
  Future<Result<void>> save(EmergencyPost p) async {
    try {
      await _db
          .into(_db.emergencyPosts)
          .insertOnConflictUpdate(
            EmergencyPostsCompanion.insert(
              id: p.id,
              type: p.type.name,
              why: p.why,
              needs: Value(p.needs.join('|')),
              createdAt: p.createdAt,
              syncStatus: p.syncStatus.name,
            ),
          );
      return const Ok(null);
    } catch (e, st) {
      logError('drift_emergency_repository', e, st);
      return const Err(
        StorageFailure('No se pudo guardar tu pedido en el teléfono.'),
      );
    }
  }

  @override
  Future<Result<void>> updateStatus(String id, SyncStatus status) async {
    try {
      await (_db.update(_db.emergencyPosts)..where((t) => t.id.equals(id)))
          .write(EmergencyPostsCompanion(syncStatus: Value(status.name)));
      return const Ok(null);
    } catch (e, st) {
      logError('drift_emergency_repository', e, st);
      return const Err(StorageFailure('No se pudo actualizar el estado.'));
    }
  }

  @override
  Stream<List<EmergencyPost>> watchAll() {
    final q = _db.select(_db.emergencyPosts)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    return q.watch().map((rows) => rows.map(_toDomain).toList());
  }

  EmergencyPost _toDomain(EmergencyRow r) => EmergencyPost(
    id: r.id,
    type: EmergencyType.values.byName(r.type),
    why: r.why,
    needs: r.needs.isEmpty ? const [] : r.needs.split('|'),
    createdAt: r.createdAt,
    syncStatus: SyncStatus.values.byName(r.syncStatus),
  );
}
