import 'dart:math' as math;

import 'package:flutter/material.dart';

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
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            for (final t in trades)
              ChoiceChip(
                label: Text(t),
                selected: filters.trade == t,
                onSelected: (_) => ctl.setTrade(t),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('Ordenar:'),
            const SizedBox(width: 8),
            ChoiceChip(
              label: const Text('Más recomendados'),
              selected: filters.sort == ExploreSort.recommended,
              onSelected: (_) => ctl.setSort(ExploreSort.recommended),
            ),
            const SizedBox(width: 8),
            ChoiceChip(
              label: const Text('Más cerca'),
              selected: filters.sort == ExploreSort.nearest,
              onSelected: (_) => ctl.setSort(ExploreSort.nearest),
            ),
          ],
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
    (AppTheme.coralSoft, Color(0xFF4A1F00)),
    (AppTheme.mint, Color(0xFF0B3D2E)),
    (AppTheme.sky, Color(0xFF12304D)),
    (AppTheme.sun, Color(0xFF4A1F00)),
    (Color(0xFFE9E3FF), Color(0xFF3B2790)),
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
                        : 'Lo recomiendan ${vb.example} vecinos (ejemplo)'
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

/// Mapa. Sin coordenadas reales (todo es de ejemplo) se muestra un ESCENARIO DE DEMOSTRACIÓN
/// claramente rotulado como simulado: la distancia es la aproximada, el ángulo es ilustrativo.
class _MapView extends StatefulWidget {
  const _MapView({required this.items});

  final List<ExploreItem> items;

  @override
  State<_MapView> createState() => _MapViewState();
}

class _MapViewState extends State<_MapView> {
  int _selected = 0;

  static Offset _pos(ExploreItem i, Size size) {
    // Ángulo estable según la persona; radio según la distancia aproximada (máx. 1,2 km).
    final angle = (i.listing.id.hashCode.abs() % 360) * math.pi / 180;
    final r = ((i.distanceMeters ?? 600) / 1200).clamp(0.12, 0.92);
    final half = size.shortestSide / 2 - 28;
    return Offset(
      size.width / 2 + math.cos(angle) * r * half,
      size.height / 2 + math.sin(angle) * r * half,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = widget.items;
    final sel = items[_selected.clamp(0, items.length - 1)];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: 300,
            child: LayoutBuilder(
              builder: (context, c) {
                final size = Size(c.maxWidth, c.maxHeight);
                return Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(painter: _DemoMapPainter()),
                    ),
                    Positioned(
                      left: size.width / 2 - 9,
                      top: size.height / 2 - 9,
                      child: const _YouDot(),
                    ),
                    for (var k = 0; k < items.length; k++)
                      Positioned(
                        left: _pos(items[k], size).dx - 22,
                        top: _pos(items[k], size).dy - 22,
                        child: Semantics(
                          button: true,
                          selected: k == _selected,
                          label:
                              '${items[k].listing.title}, ${items[k].provider.name}',
                          child: GestureDetector(
                            onTap: () => setState(() => _selected = k),
                            child: SizedBox(
                              width: 44,
                              height: 44,
                              child: Icon(
                                Icons.location_on,
                                size: k == _selected ? 44 : 34,
                                color: k == _selected
                                    ? AppTheme.coral
                                    : AppTheme.brand,
                              ),
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
        const SizedBox(height: 8),
        Text(
          'Mapa de demostración (simulado). Las posiciones son ilustrativas: '
          'no son lugares reales.',
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
    label: 'Tu zona (demostración)',
    child: Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: AppTheme.brand,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [
          BoxShadow(color: Color(0x665B3FC4), blurRadius: 12, spreadRadius: 6),
        ],
      ),
    ),
  );
}

class _DemoMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFF3EBDD),
    );
    final park = Paint()..color = const Color(0xFFD9EBCF);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * .05,
          size.height * .08,
          size.width * .28,
          size.height * .26,
        ),
        const Radius.circular(16),
      ),
      park,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * .62,
          size.height * .66,
          size.width * .3,
          size.height * .24,
        ),
        const Radius.circular(16),
      ),
      park,
    );
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    for (final f in [.25, .5, .78]) {
      canvas.drawLine(
        Offset(0, size.height * f),
        Offset(size.width, size.height * f),
        road,
      );
      canvas.drawLine(
        Offset(size.width * f, 0),
        Offset(size.width * f, size.height),
        road,
      );
    }
    canvas.drawLine(
      Offset(0, size.height * .95),
      Offset(size.width, size.height * .1),
      road..strokeWidth = 8,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

/// Radar por RANGOS de distancia: círculos concéntricos con cuántos recursos hay en cada uno.
/// No coloca a nadie en un punto del plano (no hay posiciones reales, solo distancias aproximadas).
class _RadarView extends StatefulWidget {
  const _RadarView({required this.items});

  final List<ExploreItem> items;

  @override
  State<_RadarView> createState() => _RadarViewState();
}

class _RadarViewState extends State<_RadarView> {
  int? _range;

  static const _ranges = [
    (0.0, 300.0, 'Hasta 300 m'),
    (300.0, 600.0, '300 – 600 m'),
    (600.0, 1000.0, '600 m – 1 km'),
    (1000.0, double.infinity, 'Más de 1 km'),
  ];

  int _indexOf(ExploreItem i) {
    final d = i.distanceMeters ?? double.infinity;
    for (var k = 0; k < _ranges.length; k++) {
      if (d >= _ranges[k].$1 && d < _ranges[k].$2) {
        return k;
      }
    }
    return _ranges.length - 1;
  }

  void _pick(int? k) {
    HapticFeedback.selectionClick();
    setState(() => _range = _range == k ? null : k);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final counts = List<int>.filled(_ranges.length, 0);
    for (final i in widget.items) {
      counts[_indexOf(i)]++;
    }
    final shown = _range == null
        ? widget.items
        : widget.items.where((i) => _indexOf(i) == _range).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: AspectRatio(
              aspectRatio: 1,
              child: LayoutBuilder(
                builder: (context, c) => GestureDetector(
                  onTapUp: (d) {
                    final center = Offset(c.maxWidth / 2, c.maxHeight / 2);
                    final r = (d.localPosition - center).distance;
                    final step = c.maxWidth / 2 * 0.94 / _ranges.length;
                    final k = (r / step).floor();
                    if (k >= 0 && k < _ranges.length) {
                      _pick(k);
                    }
                  },
                  child: ExcludeSemantics(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(
                        begin: MediaQuery.disableAnimationsOf(context)
                            ? 1
                            : 0.85,
                        end: 1,
                      ),
                      duration: const Duration(milliseconds: 450),
                      curve: Curves.easeOutBack,
                      builder: (context, t, _) => CustomPaint(
                        painter: _RadarPainter(
                          counts: counts,
                          selected: _range,
                          scheme: theme.colorScheme,
                          progress: t,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Distancias aproximadas. No mostramos posiciones exactas.',
          style: theme.textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        // Mismo control, accesible: los rangos también son chips.
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            for (var k = 0; k < _ranges.length; k++)
              ChoiceChip(
                label: Text('${_ranges[k].$3} (${counts[k]})'),
                selected: _range == k,
                onSelected: (_) => _pick(k),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (shown.isEmpty)
          const EmptyState(
            icon: Icons.radar,
            title: 'Nada en este rango',
            message: 'Toca otro círculo para ver más.',
          )
        else
          for (final i in shown) _ExploreCard(item: i),
      ],
    );
  }
}

class _RadarPainter extends CustomPainter {
  _RadarPainter({
    required this.counts,
    required this.selected,
    required this.scheme,
    required this.progress,
  });

  final List<int> counts;
  final int? selected;
  final ColorScheme scheme;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final outer = size.shortestSide / 2 * 0.94 * progress;
    final step = outer / counts.length;
    for (var i = counts.length - 1; i >= 0; i--) {
      final fill = Paint()
        ..color = selected == i
            ? scheme.primaryContainer
            : (i.isEven
                  ? scheme.surfaceContainerLow
                  : scheme.surfaceContainerHigh);
      canvas.drawCircle(center, step * (i + 1), fill);
      canvas.drawCircle(
        center,
        step * (i + 1),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = selected == i ? 3 : 1.5
          ..color = selected == i ? scheme.primary : scheme.outlineVariant,
      );
    }
    for (var i = 0; i < counts.length; i++) {
      final pos = center + Offset(0, -(step * (i + 1) - step * 0.3));
      canvas.drawCircle(
        pos,
        16,
        Paint()..color = scheme.surfaceContainerLowest,
      );
      canvas.drawCircle(
        pos,
        16,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = selected == i ? scheme.primary : scheme.outline,
      );
      final tp = TextPainter(
        text: TextSpan(
          text: '${counts[i]}',
          style: TextStyle(
            color: scheme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, pos - Offset(tp.width / 2, tp.height / 2));
    }
    canvas.drawCircle(
      center,
      step * 0.36,
      Paint()..color = const Color(0xFFFF795F),
    );
    final you = TextPainter(
      text: const TextSpan(
        text: 'Tú',
        style: TextStyle(
          color: Color(0xFF2A1670),
          fontSize: 15,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    you.paint(canvas, center - Offset(you.width / 2, you.height / 2));
  }

  @override
  bool shouldRepaint(covariant _RadarPainter old) =>
      old.selected != selected ||
      old.progress != progress ||
      !_same(old.counts, counts);

  static bool _same(List<int> a, List<int> b) {
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }
    return true;
  }
}
