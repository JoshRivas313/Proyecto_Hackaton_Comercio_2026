import '../../../core/result.dart';

/// Quién hace la oferta en una negociación.
enum OfferParty { client, provider }

/// Estado de una versión de las condiciones.
/// - pending: es la versión vigente y espera respuesta.
/// - countered: la otra parte respondió con una contraoferta (queda en el historial).
/// - accepted: se aceptó y generó el trato.
/// - rejected: la otra parte la rechazó.
/// - discarded: ya no está disponible porque el pedido se asignó a otra propuesta.
enum OfferStatus { pending, countered, accepted, rejected, discarded }

/// Una versión de las condiciones (precio y otras condiciones) de un prestador para un pedido.
/// Por cada pedido y prestador solo puede haber UNA versión vigente (`pending`).
class OfferVersion {
  const OfferVersion({
    required this.id,
    required this.needId,
    required this.providerId,
    required this.by,
    required this.priceSoles,
    required this.priceLabel,
    required this.status,
    required this.createdAt,
    this.conditions,
  });

  final String id;
  final String needId;
  final String providerId;
  final OfferParty by;
  final int priceSoles;
  final String priceLabel;
  final String? conditions;
  final OfferStatus status;
  final DateTime createdAt;

  OfferVersion withStatus(OfferStatus s) => OfferVersion(
    id: id,
    needId: needId,
    providerId: providerId,
    by: by,
    priceSoles: priceSoles,
    priceLabel: priceLabel,
    conditions: conditions,
    status: s,
    createdAt: createdAt,
  );
}

abstract interface class NegotiationRepository {
  /// Guarda varias versiones juntas (todo o nada).
  Future<Result<void>> saveAll(List<OfferVersion> versions);

  Future<List<OfferVersion>> forNeed(String needId);

  Stream<List<OfferVersion>> watchAll();
}

/// Versión vigente (pendiente) de un prestador para un pedido, o `null`.
OfferVersion? currentOffer(List<OfferVersion> all, String providerId) => all
    .where((v) => v.providerId == providerId && v.status == OfferStatus.pending)
    .lastOrNull;

/// Último estado conocido de la negociación con un prestador (para ocultar rechazadas).
OfferVersion? lastOffer(List<OfferVersion> all, String providerId) =>
    all.where((v) => v.providerId == providerId).lastOrNull;
