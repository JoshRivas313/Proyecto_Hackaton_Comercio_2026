import 'dart:async';

import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import '../../../core/failure.dart';
import '../../../core/result.dart';
import '../domain/chat.dart';

/// Chat LOCAL (mobile-ux): guarda los mensajes en el teléfono y, con internet, agrega una
/// respuesta AUTOMÁTICA marcada como "de ejemplo". No hay otra persona real todavía.
class DriftDealChat implements DealChatGateway {
  DriftDealChat(this._db);

  final AppDatabase _db;
  int _replies = 0;

  @override
  Future<Result<void>> send(ChatMessage m, {required bool online}) async {
    try {
      await _insert(m);
      if (online) {
        unawaited(
          Future<void>.delayed(const Duration(milliseconds: 1300), () async {
            await _insert(
              ChatMessage(
                id: '${m.id}-r',
                dealId: m.dealId,
                fromMe: false,
                text: _reply(m.text),
                createdAt: DateTime.now(),
                isExample: true,
              ),
            );
          }),
        );
      }
      return const Ok(null);
    } catch (_) {
      return const Err(StorageFailure('No se pudo guardar tu mensaje.'));
    }
  }

  Future<void> _insert(ChatMessage m) => _db
      .into(_db.chatMessages)
      .insertOnConflictUpdate(
        ChatMessagesCompanion.insert(
          id: m.id,
          dealId: m.dealId,
          fromMe: m.fromMe,
          body: m.text,
          isExample: Value(m.isExample),
          createdAt: m.createdAt,
        ),
      );

  /// Respuestas guionadas (paridad con el PWA). Siempre se muestran como "de ejemplo".
  String _reply(String text) {
    final t = text.toLowerCase();
    if (t.contains('gracias')) {
      return 'A ti, vecino. Cualquier cosa me escribes por aquí.';
    }
    if (t.contains('repetir')) {
      return 'Claro, te lo escribo de nuevo con más calma.';
    }
    if (t.contains('llegu')) return 'Perfecto, ya te veo.';
    if (t.contains('ayuda')) return 'Estoy atento. Dime qué necesitas primero.';
    if (t.contains('hora')) {
      return 'Puedo hoy en la tarde, ¿te parece a las 5 pm?';
    }
    if (t.contains('todo bien')) {
      return 'Me alegra. Quedo atento por si algo cambia.';
    }
    const seq = [
      'Hola, gracias por escribir. ¿Puedes venir hoy?',
      'Perfecto, ahí estaré. Te aviso cuando salga.',
      'Listo, quedamos así.',
    ];
    return seq[(_replies++).clamp(0, seq.length - 1)];
  }

  ChatMessage _toDomain(ChatMessageRow r) => ChatMessage(
    id: r.id,
    dealId: r.dealId,
    fromMe: r.fromMe,
    text: r.body,
    createdAt: r.createdAt,
    isExample: r.isExample,
  );

  @override
  Stream<List<ChatMessage>> watch(String dealId) =>
      (_db.select(_db.chatMessages)
            ..where((t) => t.dealId.equals(dealId))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .watch()
          .map((rows) => rows.map(_toDomain).toList());

  @override
  Stream<List<ChatMessage>> watchAll() =>
      (_db.select(_db.chatMessages)
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .watch()
          .map((rows) => rows.map(_toDomain).toList());
}
