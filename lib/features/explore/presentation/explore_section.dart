import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../app/di/providers.dart';

import 'package:latlong2/latlong.dart';

import '../../location/presentation/location_controller.dart';

import '../../../app/widgets/empty_state.dart';

import 'package:flutter/services.dart';

import '../../../app/widgets/example_badge.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_theme.dart';

import '../../../core/geo/geo_math.dart';
import '../../directory/domain/listing.dart';
import '../../directory/domain/trades.dart';
import '../../needs/presentation/composer_sheet.dart';
import '../../needs/domain/need.dart';
import '../domain/explore_nearby.dart';
import 'explore_controller.dart';

/// "Explorar cerca": oficios y productos del barrio con Visto Bueno y distancia.
enum ExploreView { radar, map, list }

class ExploreSection extends ConsumerWidget {
  const ExploreSection({super.key, this.view = ExploreView.list});

  final ExploreView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(exploreFiltersProvider);
    final items = ref.watch(exploreItemsProvider);
    final ctl = ref.read(exploreFiltersProvider.notifier);
    final trades = filters.kind == ListingKind.service
        ? serviceTrades
        : productTrades;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SegmentedButton<ListingKind>(
          segments: const [
            ButtonSegment(value: ListingKind.service, label: Text('Servicios')),
            ButtonSegment(value: ListingKind.product, label: Text('Productos')),
          ],
          selected: {filters.kind},
          onSelectionChanged: (s) => ctl.setKind(s.first),
        ),
        const SizedBox(height: 6),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 6,
            children: [
              for (final t in trades)
                ChoiceChip(
                  visualDensity: VisualDensity.compact,
                  label: Text(t),
                  selected: filters.trade == t,
                  onSelected: (_) => ctl.setTrade(t),
                ),
              const SizedBox(width: 6),
              ChoiceChip(
                visualDensity: VisualDensity.compact,
                avatar: const Icon(Icons.star_outline, size: 16),
                label: const Text('Recomendados'),
                selected: filters.sort == ExploreSort.recommended,
                onSelected: (_) => ctl.setSort(ExploreSort.recommended),
              ),
              ChoiceChip(
                visualDensity: VisualDensity.compact,
                avatar: const Icon(Icons.near_me_outlined, size: 16),
                label: const Text('Más cerca'),
                selected: filters.sort == ExploreSort.nearest,
                onSelected: (_) => ctl.setSort(ExploreSort.nearest),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        items.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (_, _) => const Text(
            'No pudimos cargar lo que hay cerca. Inténtalo otra vez.',
          ),
          data: (list) => _Results(view: view, items: list),
        ),
      ],
    );
  }
}

class _ExploreCard extends StatelessWidget {
  const _ExploreCard({required this.item});

  final ExploreItem item;

  // (fondo, texto) por persona: identidad sin foto y sin inventar nada.
  static const _tints = [
    (AppTheme.coralSoft, AppTheme.onSun),
    (AppTheme.mint, AppTheme.onMint),
    (AppTheme.sky, AppTheme.onSky),
    (AppTheme.sun, AppTheme.onSun),
    (AppTheme.lilac, AppTheme.deepViolet),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = item.listing;
    final vb = item.vistoBueno;
    final tint = _tints[item.provider.id.hashCode.abs() % _tints.length];
    final trade = l.kind == ListingKind.service ? item.provider.role : l.trade;
    final dist = item.distanceMeters == null
        ? null
        : 'a ${formatDistance(item.distanceMeters!)}${item.distanceIsReal ? '' : ' (aprox.)'}';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: tint.$1,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    _initials(item.provider.name),
                    style: TextStyle(
                      color: tint.$2,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.title, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          _Pill(icon: Icons.handyman_outlined, text: trade),
                          if (dist != null)
                            _Pill(icon: Icons.place_outlined, text: dist),
                        ],
                      ),
                    ],
                  ),
                ),
                const ExampleBadge(),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppTheme.confirmed,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l.availability,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                Flexible(
                  child: Text(
                    l.reference,
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.verified_outlined,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    vb.isEmpty
                        ? 'Aún sin recomendaciones'
                        : 'Lo recomiendan ${vb.example} vecinos'
                              '${vb.confirmed > 0 ? ' + ${vb.confirmed} tuya${vb.confirmed == 1 ? '' : 's'}' : ''}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => showComposer(
                  context,
                  kind: l.kind == ListingKind.service
                      ? NeedKind.service
                      : NeedKind.product,
                  text: l.requestText,
                ),
                child: Text(
                  l.kind == ListingKind.service
                      ? 'Pedir este servicio'
                      : 'Lo quiero',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _initials(String n) =>
      n.split(' ').where((w) => w.isNotEmpty).map((w) => w[0]).take(2).join();
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: s.primaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: s.onPrimaryContainer),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: s.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Resultados según la vista. Radar, Mapa y Lista comparten datos y filtros.
class _Results extends StatelessWidget {
  const _Results({required this.view, required this.items});

  final ExploreView view;
  final List<ExploreItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const EmptyState(
        icon: Icons.search_off_outlined,
        title: 'Nada con ese rubro',
        message: 'Prueba con otro rubro.',
      );
    }
    return switch (view) {
      ExploreView.list => Column(
        children: [for (final i in items) _ExploreCard(item: i)],
      ),
      ExploreView.radar => _RadarView(items: items),
      ExploreView.map => _MapView(items: items),
    };
  }
}

/// Mapa con cartografía real (OpenStreetMap, necesita internet para las teselas).
/// Los recursos de ejemplo no tienen coordenadas reales: se colocan alrededor de un punto
/// de DEMOSTRACIÓN (Plaza de Armas de Chimbote) según su distancia aproximada y se rotulan «Demo».
class _MapView extends ConsumerStatefulWidget {
  const _MapView({required this.items});

  final List<ExploreItem> items;

  @override
  ConsumerState<_MapView> createState() => _MapViewState();
}

class _MapViewState extends ConsumerState<_MapView> {
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
        _ExploreCard(item: sel),
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

/// Radar de proximidad. El usuario va al centro; los anillos marcan 250 m, 500 m, 750 m y 1 km.
/// - Con coordenadas REALES se dibuja el marcador en su rumbo y distancia verdaderos.
/// - Con solo una distancia aproximada NO se inventa una dirección: cada anillo tiene UNA
///   burbuja de grupo (no representa un rumbo) y sus recursos se eligen en tarjetas grandes.
class _RadarView extends ConsumerStatefulWidget {
  const _RadarView({required this.items});

  final List<ExploreItem> items;

  @override
  ConsumerState<_RadarView> createState() => _RadarViewState();
}

class _RadarViewState extends ConsumerState<_RadarView> {
  static const _rings = [250.0, 500.0, 750.0, 1000.0];
  static const _ringLabels = ['250 m', '500 m', '750 m', '1 km'];
  // Ángulo (desde el norte, en grados) de la burbuja de cada anillo: solo para que no se
  // superpongan entre sí. No significa que el recurso esté en esa dirección.
  static const _bubbleAngles = [135.0, 315.0, 225.0, 45.0];
  int? _ring; // 0..3 = anillo; 4 = más de 1 km
  String? _selectedId;

  static int _ringOf(ExploreItem i) {
    final d = i.distanceMeters ?? double.infinity;
    for (var k = 0; k < _rings.length; k++) {
      if (d < _rings[k]) return k;
    }
    return _rings.length;
  }

  static bool _isReal(ExploreItem i) =>
      i.distanceIsReal &&
      !i.listing.isExample &&
      i.listing.latitude != null &&
      i.listing.longitude != null;

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
    final groups = List.generate(_rings.length + 1, (_) => <ExploreItem>[]);
    for (final i in widget.items) {
      groups[_ringOf(i)].add(i);
    }
    final ring =
        _ring ?? groups.indexWhere((g) => g.isNotEmpty).clamp(0, _rings.length);
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
                  double ringR(int k) => outer * (k + 1) / _rings.length;
                  final real = [
                    for (final i in widget.items)
                      if (_isReal(i) && loc != null) i,
                  ];
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: ExcludeSemantics(
                          child: CustomPaint(
                            painter: _RadarPainter(
                              labels: _ringLabels,
                              selected: ring < _rings.length ? ring : null,
                              scheme: theme.colorScheme,
                            ),
                          ),
                        ),
                      ),
                      // Una burbuja de grupo por anillo con recursos (48 dp o más).
                      for (var k = 0; k < _rings.length; k++)
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
                                label: _ringLabels[k],
                                items: groups[k],
                                selected: ring == k,
                                onTap: () => _pickRing(k),
                              ),
                            );
                          }(),
                      // Marcadores con coordenadas reales: rumbo y distancia verdaderos.
                      for (final i in real)
                        () {
                          final dLat = i.listing.latitude! - loc!.lat;
                          final dLng =
                              (i.listing.longitude! - loc.lng) *
                              math.cos(loc.lat * math.pi / 180);
                          final b = math.atan2(dLng, dLat);
                          final r =
                              ((i.distanceMeters ?? 0) / _rings.last).clamp(
                                0.1,
                                1.0,
                              ) *
                              outer;
                          final p =
                              center +
                              Offset(math.sin(b) * r, -math.cos(b) * r);
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
                                _ring = _ringOf(i);
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
            label: Text('Más de 1 km (${groups[_rings.length].length})'),
            selected: ring == _rings.length,
            onSelected: (_) => _pickRing(_rings.length),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          ring == _rings.length
              ? 'A más de 1 km'
              : 'Hasta ${_ringLabels[ring]} · ${inRing.length} ${inRing.length == 1 ? 'recurso' : 'recursos'}',
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
          if (selected != null) _ExploreCard(item: selected),
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
    final color = mixed ? AppTheme.brand : _RadarViewState._color(items.first);
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
                      : _RadarViewState._icon(items.first),
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
                color: _RadarViewState._color(item),
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppTheme.coral : Colors.white,
                  width: 3,
                ),
              ),
              child: Icon(
                _RadarViewState._icon(item),
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
                    color: _RadarViewState._color(item),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _RadarViewState._icon(item),
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
