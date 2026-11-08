enum NeedKind { service, product, loan, help }

/// Plazo con el que se necesita (paridad con "¿Para cuándo lo necesitas?" del PWA).
enum Urgency { now, today, tomorrow, thisWeek }

/// Lo único que la UI conoce del envío: Pendiente / Enviada / Error.
enum SyncStatus { pending, sent, error }

class Need {
  const Need({
    required this.id,
    required this.kind,
    required this.text,
    required this.urgency,
    required this.createdAt,
    required this.syncStatus,
    this.details,
    this.photoPath,
    this.categoryId,
  });

  /// UUID de cliente: identifica la necesidad también en la cola de pendientes.
  final String id;
  final NeedKind kind;
  final String text;
  final Urgency urgency;
  final DateTime createdAt;
  final SyncStatus syncStatus;

  /// Detalles opcionales: tiempo, a cambio de qué y más información.
  final String? details;

  /// Foto del problema, guardada solo en el teléfono.
  final String? photoPath;

  /// Categoría de servicio elegida (id de `tradeCategories`), si la hay.
  final String? categoryId;

  Need copyWith({SyncStatus? syncStatus}) => Need(
    id: id,
    kind: kind,
    text: text,
    urgency: urgency,
    createdAt: createdAt,
    syncStatus: syncStatus ?? this.syncStatus,
    details: details,
    photoPath: photoPath,
    categoryId: categoryId,
  );
}
