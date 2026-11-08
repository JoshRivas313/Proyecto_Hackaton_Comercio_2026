import 'package:flutter/material.dart';

import '../../../app/widgets/empty_state.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../directory/domain/listing.dart';
import '../../directory/domain/trades.dart';
import '../domain/explore_nearby.dart';
import 'explore_controller.dart';
import 'explore_card.dart';
import 'explore_map_view.dart';
import 'explore_radar_view.dart';

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
        children: [for (final i in items) ExploreCard(item: i)],
      ),
      ExploreView.radar => ExploreRadarView(items: items),
      ExploreView.map => ExploreMapView(items: items),
    };
  }
}
