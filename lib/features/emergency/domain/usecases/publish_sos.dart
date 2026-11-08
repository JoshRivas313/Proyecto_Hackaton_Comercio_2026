import 'dart:convert';

import '../../../../core/clock.dart';
import '../../../../core/failure.dart';
import '../../../../core/ids.dart';
import '../../../../core/result.dart';
import '../../../needs/domain/need.dart';
import '../../../sync/domain/outbox_queue.dart';
import '../emergency.dart';

/// Guarda un pedido de ayuda en el teléfono y, si NO es un caso sensible, lo encola.
///
/// Los casos sensibles (violencia) quedan SOLO en el teléfono: esta versión no avisa a nadie
/// y la pantalla lo dice. Nunca se muestra una respuesta de ejemplo como si fuera real.
class PublishSos {
  PublishSos({
    required this.posts,
    required this.outbox,
    required this.clock,
    required this.ids,
  });

  final EmergencyRepository posts;
  final OutboxQueue outbox;
  final Clock clock;
  final IdGenerator ids;

  Future<Result<EmergencyPost>> call({
    required EmergencyType type,
    required String why,
    List<String> needs = const [],
  }) async {
    final clean = why.trim();
    if (clean.length < 3) {
      return const Err(ValidationFailure('Cuenta en pocas palabras qué pasó.'));
    }
    final now = clock.now();
    final post = EmergencyPost(
      id: ids.newUuid(),
      type: type,
      why: clean,
      needs: needs,
      createdAt: now,
      syncStatus: SyncStatus.pending,
    );
    final saved = await posts.save(post);
    if (saved case Err(:final failure)) {
      return Err(failure);
    }
    if (!type.isPrivate) {
      final queued = await outbox.enqueue(
        OutboxOp(
          id: post.id,
          type: 'sos',
          payload: jsonEncode({
            'type': type.name,
            'why': clean,
            'needs': needs,
          }),
          createdAt: now,
        ),
      );
      if (queued case Err(:final failure)) {
        return Err(failure);
      }
    }
    return Ok(post);
  }
}
