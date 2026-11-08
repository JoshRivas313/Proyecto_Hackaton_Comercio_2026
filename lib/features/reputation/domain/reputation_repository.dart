import '../../../core/result.dart';
import 'interaction.dart';

abstract interface class ReputationRepository {
  Future<Result<void>> record(Interaction interaction);

  /// Calificaciones recibidas como PRESTADOR (las únicas que cuentan para su reputación).
  Future<List<Interaction>> forProvider(String providerId);

  /// Todas las calificaciones de un trato (una por participante).
  Future<List<Interaction>> byDeal(String dealId);

  Stream<List<Interaction>> watchAll();
}
