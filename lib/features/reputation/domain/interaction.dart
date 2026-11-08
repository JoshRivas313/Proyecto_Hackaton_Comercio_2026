/// A quién se califica: al prestador (lo hace el cliente) o al cliente (lo hace el prestador).
enum RatedRole { provider, client }

/// Un trato cerrado y calificado. Es la ÚNICA fuente de reputación confirmada
/// y de Visto Bueno real.
class Interaction {
  const Interaction({
    required this.id,
    required this.dealId,
    required this.providerId,
    required this.raterId,
    required this.stars,
    required this.recommended,
    required this.closedAt,
    this.comment = '',
    this.about = RatedRole.provider,
  });

  final String id;
  final String dealId;
  final String providerId;

  /// Quién califica. Hoy es siempre la persona de este teléfono; con cuentas será el id del usuario.
  final String raterId;
  final int stars;
  final bool recommended;
  final DateTime closedAt;
  final String comment;

  /// Rol de la persona calificada. Las valoraciones como cliente y como prestador son distintas.
  final RatedRole about;
}
