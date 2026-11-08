import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../app/di/providers.dart';

import 'package:latlong2/latlong.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_theme.dart';

import '../domain/explore_nearby.dart';
import 'explore_card.dart';

/// Mapa con cartografía real (OpenStreetMap, necesita internet para las teselas).
/// Los recursos de ejemplo no tienen coordenadas reales: se colocan alrededor de un punto
/// de DEMOSTRACIÓN (Plaza de Armas de Chimbote) según su distancia aproximada y se rotulan «Demo».
class ExploreMapView extends ConsumerStatefulWidget {
  const ExploreMapView({super.key, required this.items});

  final List<ExploreItem> items;

  @override
  ConsumerState<ExploreMapView> createState() => _ExploreMapViewState();
}

class _ExploreMapViewState extends ConsumerState<ExploreMapView> {
  static const _center = LatLng(-9.0745, -78.5936);
  int _selected = 0;

  LatLng _pos(ExploreItem i) {
    final l = i.listing;
    if (!l.isExample && l.latitude != null && l.longitude != null) {
      return LatLng(l.latitude!, l.longitude!);
    }
    // Demo: rumbo ilustrativo estable, distancia = la aproximada del recurso.
    final bearing = (l.id.hashCode.abs() % 360) * math.pi / 180;
    final m = i.distanceMeters ?? 600;
    return LatLng(
      _center.latitude + (m * math.cos(bearing)) / 111320,
      _center.longitude +
          (m * math.sin(bearing)) /
              (111320 * math.cos(_center.latitude * math.pi / 180)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = widget.items;
    final online = ref.watch(onlineProvider).value ?? true;
    final sel = items[_selected.clamp(0, items.length - 1)];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: 320,
            child: Stack(
              children: [
                FlutterMap(
                  options: const MapOptions(
                    initialCenter: _center,
                    initialZoom: 15,
                    minZoom: 12,
                    maxZoom: 18,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'pe.redbarrio.app',
                    ),
                    MarkerLayer(
                      markers: [
                        const Marker(
                          point: _center,
                          width: 24,
                          height: 24,
                          child: _YouDot(),
                        ),
                        for (var k = 0; k < items.length; k++)
                          Marker(
                            point: _pos(items[k]),
                            width: 48,
                            height: 48,
                            child: Semantics(
                              button: true,
                              selected: k == _selected,
                              label:
                                  '${items[k].listing.title}, ${items[k].provider.name}',
                              child: GestureDetector(
                                onTap: () => setState(() => _selected = k),
                                child: Icon(
                                  Icons.location_on,
                                  size: k == _selected ? 46 : 36,
                                  color: k == _selected
                                      ? AppTheme.coral
                                      : AppTheme.brand,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const RichAttributionWidget(
                      attributions: [TextSourceAttribution('© OpenStreetMap')],
                    ),
                  ],
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppTheme.sun,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      child: Text(
                        'Recursos de prueba',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          color: AppTheme.onSun,
                        ),
                      ),
                    ),
                  ),
                ),
                if (!online)
                  Positioned(
                    left: 8,
                    right: 8,
                    bottom: 28,
                    child: Material(
                      color: theme.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Sin internet: las calles del mapa no se pueden cargar. Usa la Lista, que funciona sin conexión.',
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Calles reales. Los marcadores son de prueba: su rumbo es ilustrativo y '
          'la distancia es aproximada. No son direcciones de vecinos.',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        ExploreCard(item: sel),
      ],
    );
  }
}

class _YouDot extends StatelessWidget {
  const _YouDot();

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Centro del mapa',
    child: Container(
      decoration: BoxDecoration(
        color: AppTheme.brand,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [
          BoxShadow(
            color: AppTheme.shadowBrand,
            blurRadius: 10,
            spreadRadius: 4,
          ),
        ],
      ),
    ),
  );
}
