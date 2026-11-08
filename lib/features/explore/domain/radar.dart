import 'dart:math' as math;

import 'explore_nearby.dart';

/// Radios de los anillos del radar, en metros, y sus etiquetas.
const radarRings = [250.0, 500.0, 750.0, 1000.0];
const radarRingLabels = ['250 m', '500 m', '750 m', '1 km'];

/// Anillo al que pertenece un recurso: 0..3 según su distancia; `radarRings.length` = más de 1 km
/// (o sin distancia conocida).
int ringOf(ExploreItem item) {
  final d = item.distanceMeters ?? double.infinity;
  for (var k = 0; k < radarRings.length; k++) {
    if (d < radarRings[k]) return k;
  }
  return radarRings.length;
}

/// `true` solo si el recurso tiene coordenadas VÁLIDAS y no es de prueba: únicamente entonces
/// se puede dibujar en su rumbo real. Con una distancia aproximada no se inventa dirección.
bool hasRealPosition(ExploreItem item) =>
    item.distanceIsReal &&
    !item.listing.isExample &&
    item.listing.latitude != null &&
    item.listing.longitude != null;

/// Agrupa los recursos por anillo (un grupo por anillo, más uno final para «más de 1 km»).
List<List<ExploreItem>> groupByRing(Iterable<ExploreItem> items) {
  final groups = List.generate(radarRings.length + 1, (_) => <ExploreItem>[]);
  for (final i in items) {
    groups[ringOf(i)].add(i);
  }
  return groups;
}

/// Primer anillo con recursos (o el último si no hay ninguno): es el que se muestra al abrir.
int firstNonEmptyRing(List<List<ExploreItem>> groups) =>
    groups.indexWhere((g) => g.isNotEmpty).clamp(0, radarRings.length);

/// Posición polar real de un recurso respecto al usuario.
/// [bearing] va en radianes desde el norte (sentido horario); [fraction] es la distancia como
/// proporción del radio del radar (acotada a 0,1–1,0 para que siempre sea visible).
({double bearing, double fraction}) realPosition(
  ExploreItem item,
  double userLat,
  double userLng,
) {
  final dLat = item.listing.latitude! - userLat;
  final dLng =
      (item.listing.longitude! - userLng) * math.cos(userLat * math.pi / 180);
  return (
    bearing: math.atan2(dLng, dLat),
    fraction: ((item.distanceMeters ?? 0) / radarRings.last).clamp(0.1, 1.0),
  );
}
