import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/di/providers.dart';
import '../../explore/presentation/explore_section.dart';
import '../../location/presentation/location_controller.dart';
import 'composer_sheet.dart';
import 'category_tiles.dart';
import 'need_labels.dart';

/// Inicio: pedir, mis necesidades y Explorar cerca.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final needs = ref.watch(needsStreamProvider);
    final loc = ref.watch(locationControllerProvider);
    final isDemo = ref.watch(syncGatewayProvider).isDemo;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          SafeArea(
            bottom: false,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.home_work_rounded,
                    color: theme.colorScheme.onPrimary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Red del barrio',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        loc.location == null
                            ? 'Zona aproximada · sin dirección exacta'
                            : 'Zona ${loc.location!.zone.lat.toStringAsFixed(2)}, ${loc.location!.zone.lng.toStringAsFixed(2)} (aprox. 1 km)',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          // Tarjeta de bienvenida: calidez y la acción principal a la vista.
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [theme.colorScheme.primary, const Color(0xFF7B5CE0)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Tu comunidad más unida',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.groups_2_rounded,
                      color: Colors.white,
                      size: 52,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Pide lo que necesitas y tus vecinos y negocios cercanos te proponen cómo resolverlo.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: theme.colorScheme.primary,
                    ),
                    onPressed: () => showComposer(context),
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('Pedir algo'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('¿Qué necesitas hoy?', style: theme.textTheme.titleLarge),
          const SizedBox(height: 10),
          const CategoryTiles(),
          const SizedBox(height: 16),
          _LocationCard(state: loc),
          const SizedBox(height: 16),
          needs.when(
            data: (list) => list.isEmpty
                ? const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.waving_hand_outlined),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Aún no pediste nada. Toca un oficio de arriba o «Pedir algo» y tus vecinos te proponen cómo resolverlo.',
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mis necesidades',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      for (final n in list)
                        Card(
                          child: ListTile(
                            leading: Icon(NeedLabels.icon(n.kind)),
                            title: Text(n.text),
                            subtitle: Text(
                              '${NeedLabels.kind(n.kind)} · Para: ${NeedLabels.urgency(n.urgency)}\n${syncLabel(n.syncStatus, isDemo: isDemo)}',
                            ),
                            isThreeLine: true,
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => context.go('/need/${n.id}'),
                          ),
                        ),
                      const SizedBox(height: 16),
                    ],
                  ),
            loading: () => const SizedBox.shrink(),
            error: (_, _) =>
                const Text('No pudimos leer tus datos. Reinicia la app.'),
          ),
          const ExploreSection(),
        ],
      ),
    );
  }
}

class _LocationCard extends ConsumerWidget {
  const _LocationCard({required this.state});

  final LocationState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.status == LocationStatus.ready) return const SizedBox.shrink();
    final loading = state.status == LocationStatus.loading;
    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tu ubicación se queda en tu teléfono. La usamos solo para calcular qué hay cerca. '
              'Cuando haya cuentas, los vecinos verán únicamente una zona de unos 1000 m.',
            ),
            if (state.status == LocationStatus.failed) ...[
              const SizedBox(height: 6),
              Text(state.message ?? 'No pudimos obtener tu ubicación.'),
            ],
            const SizedBox(height: 8),
            FilledButton(
              onPressed: loading
                  ? null
                  : () =>
                        ref.read(locationControllerProvider.notifier).request(),
              child: Text(loading ? 'Buscando…' : 'Usar mi ubicación'),
            ),
          ],
        ),
      ),
    );
  }
}
