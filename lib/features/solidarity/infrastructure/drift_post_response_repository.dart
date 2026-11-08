import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import '../../../core/failure.dart';
import '../../../core/result.dart';
import '../domain/post_response.dart';
import '../../../core/log.dart';

class DriftPostResponseRepository implements PostResponseRepository {
  DriftPostResponseRepository(this._db);

  final AppDatabase _db;

  @override
  Future<Result<void>> save(PostResponse r) async {
    try {
      await _db
          .into(_db.postResponses)
          .insertOnConflictUpdate(
            PostResponsesCompanion.insert(
              id: r.id,
              postKey: r.postKey,
              kind: r.kind.name,
              valuesJson: r.valuesJson,
              status: r.status,
              createdAt: r.createdAt,
            ),
          );
      return const Ok(null);
    } catch (e, st) {
      logError('drift_post_response_repository', e, st);
      return const Err(StorageFailure('No se pudo guardar tu propuesta.'));
    }
  }

  PostResponse _toDomain(PostResponseRow r) => PostResponse(
    id: r.id,
    postKey: r.postKey,
    kind: PostKind.values.byName(r.kind),
    values: Map<String, String>.from(jsonDecode(r.valuesJson) as Map),
    createdAt: r.createdAt,
    status: r.status,
  );

  @override
  Future<PostResponse?> byPostKey(String postKey) async {
    final r = await (_db.select(
      _db.postResponses,
    )..where((t) => t.postKey.equals(postKey))).getSingleOrNull();
    return r == null ? null : _toDomain(r);
  }

  @override
  Stream<List<PostResponse>> watchAll() =>
      (_db.select(_db.postResponses)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch()
          .map((rows) => rows.map(_toDomain).toList());
}
