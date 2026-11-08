import 'dart:async';

import '../../../../core/clock.dart';
import '../../../../core/failure.dart';
import '../../../../core/ids.dart';
import '../../../../core/result.dart';
import '../../../directory/domain/directory_repository.dart';
import '../../../needs/domain/need.dart';
import '../../../reputation/domain/calculate_reputation.dart';
import '../../../reputation/domain/interaction.dart';
import '../../../reputation/domain/reputation_repository.dart';
import '../../../reputation/domain/visto_bueno.dart';
import '../deal.dart';
import '../deal_repository.dart';
import '../proposal.dart';

/// Acepta una propuesta y genera el código de encuentro.
///
/// Un pedido solo admite UN trato. Las aceptaciones del mismo pedido se atienden de a una
/// (cola por pedido) y el guardado es "solo si no hay trato" (transacción en Drift): dos toques
/// simultáneos no pueden generar dos tratos. Entre dispositivos distintos, esta garantía
/// requerirá validación transaccional en el backend.
class AcceptProposal {
  AcceptProposal({required this.deals, required this.clock, required this.ids});

  final DealRepository deals;
  final Clock clock;
  final IdGenerator ids;

  final Map<String, Future<void>> _queues = {};

  Future<Result<Deal>> call(
    Need need,
    Proposal proposal, {
    int? priceSoles,
    String? priceLabel,
  }) async {
    final previous = _queues[need.id] ?? Future<void>.value();
    final done = Completer<void>();
    final mine = previous.then((_) => done.future);
    _queues[need.id] = mine;
    await previous;
    try {
      return await _accept(need, proposal, priceSoles, priceLabel);
    } finally {
      done.complete();
      if (identical(_queues[need.id], mine)) _queues.remove(need.id)?.ignore();
    }
  }

  Future<Result<Deal>> _accept(
    Need need,
    Proposal proposal,
    int? priceSoles,
    String? priceLabel,
  ) async {
    if (need.syncStatus != SyncStatus.sent) {
      return const Err(
        ValidationFailure(
          'Tu pedido todavía no se envió. Espera a tener internet.',
        ),
      );
    }
    final deal = Deal(
      id: ids.newUuid(),
      needId: need.id,
      providerId: proposal.providerId,
      providerName: proposal.providerName,
      priceSoles: priceSoles ?? proposal.priceSoles,
      priceLabel: priceLabel ?? proposal.priceLabel,
      code: ids.meetingCode(),
      status: DealStatus.accepted,
      acceptedAt: clock.now(),
    );
    final created = await deals.saveIfNoneForNeed(deal);
    switch (created) {
      case Err(:final failure):
        return Err(failure);
      case Ok(:final value) when !value:
        return const Err(
          ValidationFailure('Este pedido ya tiene una propuesta aceptada.'),
        );
      case Ok():
        return Ok(deal);
    }
  }
}

/// Valida el código que confirma que las dos personas se encontraron. Inicia el cronómetro.
/// Lo ingresa quien presta el servicio; en la demostración lo hace un botón marcado "demo".
class ValidateMeetingCode {
  ValidateMeetingCode({required this.deals, required this.clock});

  final DealRepository deals;
  final Clock clock;

  Future<Result<Deal>> call(String dealId, String entered) async {
    final deal = await deals.byId(dealId);
    if (deal == null) {
      return const Err(ValidationFailure('No encontramos este trato.'));
    }
    if (deal.status != DealStatus.accepted) {
      return const Err(
        ValidationFailure('El código de este trato ya fue validado.'),
      );
    }
    if (entered.trim() != deal.code) {
      return const Err(
        ValidationFailure(
          'El código no coincide. Revísalo con la otra persona.',
        ),
      );
    }
    final updated = deal.copyWith(
      status: DealStatus.inProgress,
      startedAt: clock.now(),
    );
    final saved = await deals.save(updated);
    if (saved case Err(:final failure)) return Err(failure);
    return Ok(updated);
  }
}

/// Marca el servicio como hecho (solo si el código ya se validó).
class CompleteDeal {
  CompleteDeal({required this.deals, required this.clock});

  final DealRepository deals;
  final Clock clock;

  Future<Result<Deal>> call(String dealId) async {
    final deal = await deals.byId(dealId);
    if (deal == null) {
      return const Err(ValidationFailure('No encontramos este trato.'));
    }
    if (deal.status != DealStatus.inProgress) {
      return const Err(
        ValidationFailure('Primero hay que validar el código de encuentro.'),
      );
    }
    final updated = deal.copyWith(
      status: DealStatus.awaitingRating,
      completedAt: clock.now(),
    );
    final saved = await deals.save(updated);
    if (saved case Err(:final failure)) return Err(failure);
    return Ok(updated);
  }
}

/// Resultado de cerrar un trato: la reputación antes y después, y el Visto Bueno.
class CloseOutcome {
  const CloseOutcome({
    required this.deal,
    required this.before,
    required this.after,
    required this.vistoBueno,
  });

  final Deal deal;
  final ReputationSnapshot before;
  final ReputationSnapshot after;
  final VistoBueno vistoBueno;
}

/// Califica y cierra el trato. Solo así se crea una interacción confirmada.
class CloseAndRate {
  CloseAndRate({
    required this.deals,
    required this.reputation,
    required this.directory,
    required this.clock,
    required this.ids,
    this.raterId = 'me',
  });

  final DealRepository deals;
  final ReputationRepository reputation;
  final DirectoryRepository directory;
  final Clock clock;
  final IdGenerator ids;
  final String raterId;

  Future<Result<CloseOutcome>> call(
    String dealId, {
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
    if (deal.status != DealStatus.awaitingRating) {
      return const Err(
        ValidationFailure('Primero marca el servicio como hecho.'),
      );
    }
    final provider = await directory.provider(deal.providerId);
    if (provider == null) {
      return const Err(ValidationFailure('No encontramos a esta persona.'));
    }

    final before = await reputation.forProvider(deal.providerId);
    final interaction = Interaction(
      id: ids.newUuid(),
      dealId: deal.id,
      providerId: deal.providerId,
      raterId: raterId,
      stars: stars,
      recommended: recommend,
      closedAt: clock.now(),
      comment: comment.trim(),
    );
    final recorded = await reputation.record(interaction);
    if (recorded case Err(:final failure)) return Err(failure);
    final closed = deal.copyWith(status: DealStatus.closed);
    final saved = await deals.save(closed);
    if (saved case Err(:final failure)) return Err(failure);

    final after = [...before, interaction];
    return Ok(
      CloseOutcome(
        deal: closed,
        before: calculateReputation(provider, before),
        after: calculateReputation(provider, after),
        vistoBueno: calculateVistoBueno(
          exampleCount: provider.exampleVistoBueno,
          interactions: after,
        ),
      ),
    );
  }
}
