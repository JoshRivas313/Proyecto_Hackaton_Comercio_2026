import '../../../core/clock.dart';
import '../../../core/failure.dart';
import '../../../core/ids.dart';
import '../../../core/result.dart';
import '../../sync/domain/connectivity_monitor.dart';

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.dealId,
    required this.fromMe,
    required this.text,
    required this.createdAt,
    this.isExample = false,
  });

  final String id;
  final String dealId;
  final bool fromMe;
  final String text;
  final DateTime createdAt;

  /// `true` en las respuestas automáticas de la demostración (no es una persona real).
  final bool isExample;
}

/// Chat del trato. Local (mobile-ux): Drift + respuestas de ejemplo.
/// Remoto (mobile-mejoras): tabla de Supabase y, más adelante, Matrix.
abstract interface class DealChatGateway {
  /// Guarda el mensaje. Si [online], el adaptador de demostración agrega una respuesta de ejemplo.
  Future<Result<void>> send(ChatMessage message, {required bool online});

  Stream<List<ChatMessage>> watch(String dealId);

  Stream<List<ChatMessage>> watchAll();

  /// Marca la conversación como leída (guarda la hora en que la abriste).
  Future<void> markRead(String dealId, DateTime at);

  /// Última lectura por conversación (clave: id del trato).
  Stream<Map<String, DateTime>> watchReads();
}

/// Frases rápidas (menos teclado para quien lo necesite).
const quickPhrases = [
  '¿Puedes repetir?',
  'Ya llegué',
  '¿A qué hora puedes?',
  'Necesito ayuda',
  'Todo bien',
  'Gracias',
];

class SendChatMessage {
  SendChatMessage({
    required this.gateway,
    required this.connectivity,
    required this.clock,
    required this.ids,
  });

  final DealChatGateway gateway;
  final ConnectivityMonitor connectivity;
  final Clock clock;
  final IdGenerator ids;

  Future<Result<void>> call(String dealId, String text) async {
    final clean = text.trim();
    if (clean.isEmpty) {
      return const Err(ValidationFailure('Escribe un mensaje.'));
    }
    if (clean.length > 300) {
      return const Err(
        ValidationFailure('El mensaje es muy largo (máximo 300 letras).'),
      );
    }
    return gateway.send(
      ChatMessage(
        id: ids.newUuid(),
        dealId: dealId,
        fromMe: true,
        text: clean,
        createdAt: clock.now(),
      ),
      online: await connectivity.isOnline,
    );
  }
}
