import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../location/presentation/location_controller.dart';

import '../../../app/widgets/empty_state.dart';

import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_theme.dart';

import '../../../core/geo/geo_math.dart';
import '../../directory/domain/listing.dart';
import '../domain/explore_nearby.dart';
import '../domain/radar.dart';
import 'explore_card.dart';

/// Radar de proximidad. El usuario va al centro; los anillos marcan 250 m, 500 m, 750 m y 1 km.
/// - Con coordenadas REALES se dibuja el marcador en su rumbo y distancia verdaderos.
/// - Con solo una distancia aproximada NO se inventa una dirección: cada anillo tiene UNA
///   burbuja de grupo (no representa un rumbo) y sus recursos se eligen en tarjetas grandes.
class ExploreRadarView extends ConsumerStatefulWidget {
  const ExploreRadarView({super.key, required this.items});

  final List<ExploreItem> items;

  @override
  ConsumerState<ExploreRadarView> createState() => _ExploreRadarViewState();
}

class _ExploreRadarViewState extends ConsumerState<ExploreRadarView> {
  // Ángulo (desde el norte, en grados) de la burbuja de cada anillo: solo para que no se
  // superpongan entre sí. No significa que el recurso esté en esa dirección.
  static const _bubbleAngles = [135.0, 315.0, 225.0, 45.0];
  int? _ring; // 0..3 = anillo; 4 = más de 1 km
  String? _selectedId;

  static IconData _icon(ExploreItem i) => i.listing.kind == ListingKind.service
      ? Icons.build_rounded
      : Icons.shopping_basket_rounded;

  static Color _color(ExploreItem i) => i.listing.kind == ListingKind.service
      ? AppTheme.brand
      : AppTheme.confirmed;

  void _pickRing(int k) {
    HapticFeedback.selectionClick();
    setState(() {
      _ring = k;
      _selectedId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = ref.watch(locationControllerProvider).location;
    final groups = groupByRing(widget.items);
    final ring = _ring ?? firstNonEmptyRing(groups);
    final inRing = groups[ring];
    final selected =
        inRing.where((i) => i.listing.id == _selectedId).firstOrNull ??
        inRing.firstOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: AspectRatio(
              aspectRatio: 1,
              child: LayoutBuilder(
                builder: (context, c) {
                  final center = Offset(c.maxWidth / 2, c.maxHeight / 2);
                  final outer = c.maxWidth / 2 * 0.92;
                  double ringR(int k) => outer * (k + 1) / radarRings.length;
                  final real = [
                    for (final i in widget.items)
                      if (hasRealPosition(i) && loc != null) i,
                  ];
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: ExcludeSemantics(
                          child: CustomPaint(
                            painter: _RadarPainter(
                              labels: radarRingLabels,
                              selected: ring < radarRings.length ? ring : null,
                              scheme: theme.colorScheme,
                            ),
                          ),
                        ),
                      ),
                      // Una burbuja de grupo por anillo con recursos (48 dp o más).
                      for (var k = 0; k < radarRings.length; k++)
                        if (groups[k].isNotEmpty)
                          () {
                            final a = _bubbleAngles[k] * math.pi / 180;
                            final p =
                                center +
                                Offset(
                                  math.sin(a) * ringR(k),
                                  -math.cos(a) * ringR(k),
                                );
                            const size = 56.0;
                            return Positioned(
                              left: p.dx - size / 2,
                              top: p.dy - size / 2,
                              width: size,
                              height: size,
                              child: _RingBubble(
                                label: radarRingLabels[k],
                                items: groups[k],
                                selected: ring == k,
                                onTap: () => _pickRing(k),
                              ),
                            );
                          }(),
                      // Marcadores con coordenadas reales: rumbo y distancia verdaderos.
                      for (final i in real)
                        () {
                          final pos = realPosition(i, loc!.lat, loc.lng);
                          final r = pos.fraction * outer;
                          final p =
                              center +
                              Offset(
                                math.sin(pos.bearing) * r,
                                -math.cos(pos.bearing) * r,
                              );
                          return Positioned(
                            left: p.dx - 28,
                            top: p.dy - 28,
                            width: 56,
                            height: 56,
                            child: _Marker(
                              item: i,
                              selected: selected == i,
                              onTap: () => setState(() {
                                _selectedId = i.listing.id;
                                _ring = ringOf(i);
                              }),
                            ),
                          );
                        }(),
                      Positioned(
                        left: center.dx - 24,
                        top: center.dy - 24,
                        width: 48,
                        height: 48,
                        child: Semantics(
                          label: 'Tú, en el centro del radar',
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.ink,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: const Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        Text(
          'Cada burbuja es un rango de distancia, no una dirección. No mostramos posiciones exactas.',
          style: theme.textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Center(
          child: ChoiceChip(
            label: Text('Más de 1 km (${groups[radarRings.length].length})'),
            selected: ring == radarRings.length,
            onSelected: (_) => _pickRing(radarRings.length),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          ring == radarRings.length
              ? 'A más de 1 km'
              : 'Hasta ${radarRingLabels[ring]} · ${inRing.length} ${inRing.length == 1 ? 'recurso' : 'recursos'}',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        if (inRing.isEmpty)
          const EmptyState(
            icon: Icons.radar,
            title: 'Nada en este anillo',
            message: 'Toca otra burbuja para ver más recursos.',
          )
        else ...[
          SizedBox(
            height: 112,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: inRing.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, n) => _ResourceTile(
                item: inRing[n],
                selected: selected == inRing[n],
                onTap: () => setState(() => _selectedId = inRing[n].listing.id),
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (selected != null) ExploreCard(item: selected),
        ],
      ],
    );
  }
}

/// Burbuja de grupo de un anillo: icono grande del tipo y cantidad de recursos.
class _RingBubble extends StatelessWidget {
  const _RingBubble({
    required this.label,
    required this.items,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final List<ExploreItem> items;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final mixed = items.map((i) => i.listing.kind).toSet().length > 1;
    final color = mixed
        ? AppTheme.brand
        : _ExploreRadarViewState._color(items.first);
    return Semantics(
      button: true,
      selected: selected,
      label: 'Rango de $label, ${items.length} recursos',
      child: ExcludeSemantics(
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? AppTheme.coral : Colors.white,
                    width: selected ? 4 : 3,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: AppTheme.shadowSoft,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  mixed
                      ? Icons.grid_view_rounded
                      : _ExploreRadarViewState._icon(items.first),
                  color: Colors.white,
                  size: 28,
                ),
              ),
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppTheme.coral,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Text(
                    '${items.length}',
                    style: const TextStyle(
                      color: AppTheme.onCoral,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Marcador individual (recurso con coordenadas reales).
class _Marker extends StatelessWidget {
  const _Marker({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final ExploreItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final name = item.provider.name.split(' ').first;
    return Semantics(
      button: true,
      selected: selected,
      label: '${item.listing.title}, $name',
      child: ExcludeSemantics(
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _ExploreRadarViewState._color(item),
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppTheme.coral : Colors.white,
                  width: 3,
                ),
              ),
              child: Icon(
                _ExploreRadarViewState._icon(item),
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tarjeta grande y seleccionable de un recurso del anillo elegido.
class _ResourceTile extends StatelessWidget {
  const _ResourceTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final ExploreItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = item.provider.name;
    final dist = item.distanceMeters == null
        ? null
        : '${formatDistance(item.distanceMeters!)}${item.distanceIsReal ? '' : ' aprox.'}';
    return Semantics(
      button: true,
      selected: selected,
      label: '$name, ${item.listing.title}${dist == null ? '' : ', $dist'}',
      child: ExcludeSemantics(
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 148,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: selected ? AppTheme.lilac : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: selected ? AppTheme.brand : AppTheme.outlineSoft,
                width: selected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _ExploreRadarViewState._color(item),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _ExploreRadarViewState._icon(item),
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name.split(' ').first,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.ink,
                        ),
                      ),
                      Text(
                        item.listing.kind == ListingKind.service
                            ? item.provider.role
                            : item.listing.trade,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                      if (dist != null)
                        Text(
                          dist,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.brand,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  _RadarPainter({
    required this.labels,
    required this.selected,
    required this.scheme,
  });

  final List<String> labels;
  final int? selected;
  final ColorScheme scheme;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final outer = size.shortestSide / 2 * 0.92;
    final n = labels.length;
    final step = outer / n;
    for (var i = n - 1; i >= 0; i--) {
      canvas.drawCircle(
        center,
        step * (i + 1),
        Paint()
          ..color = selected == i
              ? scheme.primaryContainer
              : (i.isEven ? AppTheme.violetTint : AppTheme.lilac),
      );
      canvas.drawCircle(
        center,
        step * (i + 1),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = selected == i ? 2.5 : 1.2
          ..color = selected == i ? scheme.primary : AppTheme.violetLine,
      );
    }
    // Etiquetas de distancia sobre el eje vertical (arriba): nunca se tapan entre sí
    // porque están separadas un anillo, y las burbujas van en las diagonales.
    for (var i = 0; i < n; i++) {
      final tp = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: TextStyle(
            color: selected == i ? scheme.primary : AppTheme.ink,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final c = center + Offset(0, -step * (i + 1));
      final r = RRect.fromRectAndRadius(
        Rect.fromCenter(center: c, width: tp.width + 14, height: 20),
        const Radius.circular(10),
      );
      canvas.drawRRect(r, Paint()..color = Colors.white);
      tp.paint(canvas, c - Offset(tp.width / 2, tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant _RadarPainter old) =>
      old.selected != selected || old.labels != labels;
}
