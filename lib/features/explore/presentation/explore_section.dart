import 'package:flutter/material.dart';

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
class ExploreSection extends ConsumerWidget {
  const ExploreSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final filters = ref.watch(exploreFiltersProvider);
    final items = ref.watch(exploreItemsProvider);
    final ctl = ref.read(exploreFiltersProvider.notifier);
    final trades = filters.kind == ListingKind.service
        ? serviceTrades
        : productTrades;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Explorar cerca', style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
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
          data: (list) => list.isEmpty
              ? const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No hay resultados con ese rubro por ahora.'),
                  ),
                )
              : Column(children: [for (final i in list) _ExploreCard(item: i)]),
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
