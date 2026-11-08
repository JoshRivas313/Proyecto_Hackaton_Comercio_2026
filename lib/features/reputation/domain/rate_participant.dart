import '../../../core/clock.dart';
import '../../../core/failure.dart';
import '../../../core/ids.dart';
import '../../../core/result.dart';
import '../../proposals/domain/deal.dart';
import '../../proposals/domain/deal_repository.dart';
import 'interaction.dart';
import 'reputation_repository.dart';

/// Identificador del cliente en este teléfono (con cuentas será el id del usuario).
const clientId = 'me';

/// Calificación bidireccional una vez finalizado el servicio.
///  · El cliente califica al prestador y el prestador califica al cliente.
///  · Una sola evaluación por participante y por trato (nadie se califica a sí mismo).
///  · Son independientes: ninguna es requisito de la otra ni para cerrar el trato.
///  · Las recomendaciones (Visto Bueno Vecinal) solo existen para prestadores y solo tras
///    un servicio hecho; el cliente solo recibe estrellas y comentario.
class RateParticipant {
  RateParticipant({
    required this.deals,
    required this.reputation,
    required this.clock,
    required this.ids,
  });

  final DealRepository deals;
  final ReputationRepository reputation;
  final Clock clock;
  final IdGenerator ids;

  final Set<String> _inFlight = {};

  Future<Result<Interaction>> call(
    String dealId, {
    required String raterId,
    required RatedRole about,
    required int stars,
    String comment = '',
    bool recommend = false,
  }) async {
    if (stars < 1 || stars > 5) {
      return const Err(ValidationFailure('Elige de 1 a 5 estrellas.'));
    }
    final deal = await deals.byId(dealId);
    if (deal == null) {
      return const Err(ValidationFailure('No encontramos este trato.'));
    }
    if (deal.status != DealStatus.awaitingRating &&
        deal.status != DealStatus.closed) {
      return const Err(
        ValidationFailure('Se puede calificar cuando el servicio ya terminó.'),
      );
    }
    final ratedId = about == RatedRole.provider ? deal.providerId : clientId;
    final expectedRater = about == RatedRole.provider
        ? clientId
        : deal.providerId;
    if (raterId == ratedId) {
      return const Err(ValidationFailure('No puedes calificarte a ti mismo.'));
    }
    if (raterId != expectedRater) {
      return const Err(
        ValidationFailure('Esta calificación le corresponde a la otra parte.'),
      );
    }
    final key = '$dealId|${about.name}';
    if (!_inFlight.add(key)) {
      return const Err(
        ValidationFailure('Ya se está enviando tu calificación.'),
      );
    }
    try {
      final existing = await reputation.byDeal(dealId);
      if (existing.any((i) => i.about == about)) {
        return const Err(ValidationFailure('Ya calificaste en este trato.'));
      }
      final i = Interaction(
        id: ids.newUuid(),
        dealId: dealId,
        providerId: deal.providerId,
        raterId: raterId,
        stars: stars,
        recommended: about == RatedRole.provider && recommend,
        closedAt: clock.now(),
        comment: comment.trim(),
        about: about,
      );
      final saved = await reputation.record(i);
      if (saved case Err(:final failure)) return Err(failure);
      return Ok(i);
    } finally {
      _inFlight.remove(key);
    }
  }
}

/// Cierra un trato terminado SIN calificar: calificar es opcional para las dos partes.
class CloseWithoutRating {
  CloseWithoutRating({required this.deals});

  final DealRepository deals;

  Future<Result<Deal>> call(String dealId) async {
    final deal = await deals.byId(dealId);
    if (deal == null) {
      return const Err(ValidationFailure('No encontramos este trato.'));
    }
    if (deal.status != DealStatus.awaitingRating) {
      return const Err(ValidationFailure('Este trato no está por cerrar.'));
    }
    final closed = deal.copyWith(status: DealStatus.closed);
    final saved = await deals.save(closed);
    if (saved case Err(:final failure)) return Err(failure);
    return Ok(closed);
  }
}
