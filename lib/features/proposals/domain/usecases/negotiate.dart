import '../../../../core/clock.dart';
import '../../../../core/failure.dart';
import '../../../../core/ids.dart';
import '../../../../core/result.dart';
import '../../../needs/domain/need.dart';
import '../deal.dart';
import '../deal_repository.dart';
import '../negotiation.dart';
import '../proposal.dart';
import 'deal_usecases.dart';

/// Negociación de una propuesta: aceptar, rechazar o enviar contraoferta.
///
/// Reglas:
///  · Un pedido solo puede tener UN trato (una sola propuesta aceptada).
///  · Por prestador solo hay una versión vigente de las condiciones.
///  · Cada parte responde a la versión de la OTRA (no se acepta lo propio).
///  · Préstamos, favores y donaciones no se negocian por precio.
///  · Sin servidor, la exclusividad global entre dispositivos exige validación
///    transaccional en el backend (aquí se garantiza dentro de este teléfono).
class Negotiate {
  Negotiate({
    required this.repo,
    required this.deals,
    required this.accept,
    required this.clock,
    required this.ids,
  });

  final NegotiationRepository repo;
  final DealRepository deals;
  final AcceptProposal accept;
  final Clock clock;
  final IdGenerator ids;

  static bool isPriceNegotiable(Need need, Proposal p) =>
      need.kind == NeedKind.service && p.priceSoles > 0;

  Future<Result<void>> _ensureOpen(Need need) async {
    if (await deals.byNeed(need.id) != null) {
      return const Err(
        ValidationFailure('Este pedido ya está en trato con otra propuesta.'),
      );
    }
    return const Ok(null);
  }

  /// Contraoferta de [by]: reemplaza la versión vigente de la otra parte.
  Future<Result<OfferVersion>> counter(
    Need need,
    Proposal proposal, {
    required OfferParty by,
    required int priceSoles,
    String? conditions,
  }) async {
    if (await _ensureOpen(need) case Err(:final failure)) return Err(failure);
    if (!isPriceNegotiable(need, proposal)) {
      return const Err(
        ValidationFailure('Este tipo de pedido no se negocia por precio.'),
      );
    }
    if (priceSoles <= 0) {
      return const Err(ValidationFailure('Escribe un precio mayor que cero.'));
    }
    final all = await repo.forNeed(need.id);
    final current = currentOffer(all, proposal.providerId);
    if (current != null && current.by == by) {
      return const Err(
        ValidationFailure('Ya enviaste una oferta: espera la respuesta.'),
      );
    }
    final next = OfferVersion(
      id: ids.newUuid(),
      needId: need.id,
      providerId: proposal.providerId,
      by: by,
      priceSoles: priceSoles,
      priceLabel: 'S/ $priceSoles',
      conditions: conditions?.trim().isEmpty ?? true
          ? null
          : conditions!.trim(),
      status: OfferStatus.pending,
      createdAt: clock.now(),
    );
    final saved = await repo.saveAll([
      if (current != null) current.withStatus(OfferStatus.countered),
      next,
    ]);
    if (saved case Err(:final failure)) return Err(failure);
    return Ok(next);
  }

  /// Rechaza la versión vigente de la otra parte (o la propuesta inicial si [by] es el cliente).
  Future<Result<void>> reject(
    Need need,
    Proposal proposal, {
    required OfferParty by,
  }) async {
    if (await _ensureOpen(need) case Err(:final failure)) return Err(failure);
    final all = await repo.forNeed(need.id);
    final current = currentOffer(all, proposal.providerId);
    if (current != null && current.by == by) {
      return const Err(
        ValidationFailure('Esta oferta es tuya: espera la respuesta.'),
      );
    }
    final target =
        (current ??
                OfferVersion(
                  id: ids.newUuid(),
                  needId: need.id,
                  providerId: proposal.providerId,
                  by: OfferParty.provider,
                  priceSoles: proposal.priceSoles,
                  priceLabel: proposal.priceLabel,
                  status: OfferStatus.pending,
                  createdAt: clock.now(),
                ))
            .withStatus(OfferStatus.rejected);
    return repo.saveAll([target]);
  }

  /// Acepta las condiciones vigentes de la otra parte y confirma el trato.
  /// Al aceptar, las demás negociaciones del pedido quedan descartadas.
  Future<Result<Deal>> acceptOffer(
    Need need,
    Proposal proposal, {
    required OfferParty by,
  }) async {
    final all = await repo.forNeed(need.id);
    final current = currentOffer(all, proposal.providerId);
    if (current != null && current.by == by) {
      return const Err(
        ValidationFailure(
          'No puedes aceptar tu propia oferta: espera la respuesta.',
        ),
      );
    }
    if (current == null && by == OfferParty.provider) {
      return const Err(
        ValidationFailure('No hay una oferta del cliente que aceptar.'),
      );
    }
    final price = current?.priceSoles ?? proposal.priceSoles;
    final label = current?.priceLabel ?? proposal.priceLabel;
    final deal = await accept(
      need,
      proposal,
      priceSoles: price,
      priceLabel: label,
    );
    if (deal case Err(:final failure)) return Err(failure);
    final fresh = await repo.forNeed(need.id);
    final updates = <OfferVersion>[];
    for (final v in fresh.where((v) => v.status == OfferStatus.pending)) {
      updates.add(
        v.providerId == proposal.providerId && v.id == current?.id
            ? v.withStatus(OfferStatus.accepted)
            : v.withStatus(OfferStatus.discarded),
      );
    }
    if (current == null) {
      // La propuesta inicial se aceptó tal cual: queda registrada como aceptada.
      updates.add(
        OfferVersion(
          id: ids.newUuid(),
          needId: need.id,
          providerId: proposal.providerId,
          by: OfferParty.provider,
          priceSoles: proposal.priceSoles,
          priceLabel: proposal.priceLabel,
          status: OfferStatus.accepted,
          createdAt: clock.now(),
        ),
      );
    }
    await repo.saveAll(updates);
    return deal;
  }
}
