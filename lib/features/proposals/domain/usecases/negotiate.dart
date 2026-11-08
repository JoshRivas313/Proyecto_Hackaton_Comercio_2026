import '../../../../core/clock.dart';
import '../../../../core/ids.dart';
import '../../../../core/result.dart';
import '../../../needs/domain/need.dart';
import '../deal.dart';
import '../negotiation.dart';
import '../proposal.dart';
import 'deal_usecases.dart';

/// Elección entre las propuestas iniciales de un pedido (SIN contraoferta).
///
/// Flujo: el cliente acepta o rechaza propuestas tal como llegan. Al aceptar una, las demás
/// dejan de estar disponibles y quedan en el historial como «descartadas». La contraoferta
/// existe más adelante, en el encuentro, y la maneja `CounterOfferService`.
class Negotiate {
  Negotiate({
    required this.repo,
    required this.accept,
    required this.clock,
    required this.ids,
  });

  final NegotiationRepository repo;
  final AcceptProposal accept;
  final Clock clock;
  final IdGenerator ids;

  OfferVersion _row(Need need, Proposal p, OfferStatus status) => OfferVersion(
    id: ids.newUuid(),
    needId: need.id,
    providerId: p.providerId,
    by: OfferParty.provider,
    priceSoles: p.priceSoles,
    priceLabel: p.priceLabel,
    status: status,
    createdAt: clock.now(),
  );

  /// Rechaza una propuesta inicial: sale de las disponibles y queda en el historial.
  Future<Result<void>> reject(Need need, Proposal proposal) =>
      repo.saveAll([_row(need, proposal, OfferStatus.rejected)]);

  /// Acepta la propuesta elegida. [others] son las demás propuestas disponibles del pedido.
  Future<Result<Deal>> acceptOffer(
    Need need,
    Proposal selected, {
    List<Proposal> others = const [],
  }) async {
    final deal = await accept(need, selected);
    if (deal case Err(:final failure)) return Err(failure);
    await repo.saveAll([
      _row(need, selected, OfferStatus.accepted),
      for (final o in others.where((o) => o.providerId != selected.providerId))
        _row(need, o, OfferStatus.discarded),
    ]);
    return deal;
  }
}
