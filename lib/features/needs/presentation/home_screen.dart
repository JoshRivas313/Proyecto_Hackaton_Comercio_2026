import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/di/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/demo_chip.dart';
import '../../../app/widgets/motion.dart';
import '../../../app/widgets/neighborhood_hero.dart';
import '../../location/presentation/location_controller.dart';
import '../domain/need.dart';
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

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
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
                const SizedBox(width: 8),
                const DemoChip(),
              ],
            ),
          ),
          const SizedBox(height: 14),
          // Cabecera con identidad: ilustración de barrio y mensaje humano.
          FadeSlideIn(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppTheme.brand, Color(0xFF8B6BE8)],
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tu comunidad, más conectada',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Pide lo que necesitas y tus vecinos te proponen cómo resolverlo.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const NeighborhoodHero(height: 150),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Acción principal con protagonismo: coral, grande, con tacto.
          FadeSlideIn(
            delayMs: 120,
            child: Semantics(
              button: true,
              label: 'Pedir algo',
              child: Pressable(
                onTap: () => showComposer(context),
                child: Container(
                  height: 66,
                  decoration: BoxDecoration(
                    color: AppTheme.coral,
                    borderRadius: BorderRadius.circular(33),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x40FF8A65),
                        blurRadius: 16,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const ExcludeSemantics(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          color: Color(0xFF2A1670),
                          size: 28,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Pedir algo',
                          style: TextStyle(
                            color: Color(0xFF2A1670),
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('¿Qué necesitas hoy?', style: theme.textTheme.titleLarge),
          const SizedBox(height: 10),
          const FadeSlideIn(delayMs: 220, child: CategoryTiles()),
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
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${NeedLabels.kind(n.kind)} · Para: ${NeedLabels.urgency(n.urgency)}',
                                ),
                                const SizedBox(height: 6),
                                _StatusChip(status: n.syncStatus),
                              ],
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
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => context.go('/mapa'),
              icon: const Icon(Icons.explore_outlined),
              label: const Text('Explorar cerca en el mapa'),
            ),
          ),
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
    if (state.status == LocationStatus.ready) {
      return const SizedBox.shrink();
    }
    final loading = state.status == LocationStatus.loading;
    final theme = Theme.of(context);
    final fg = theme.colorScheme.onSecondaryContainer;
    return Card(
      color: theme.colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 6, 6, 6),
        child: Row(
          children: [
            Icon(Icons.place_outlined, color: fg),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                state.status == LocationStatus.failed
                    ? (state.message ?? 'No pudimos ubicarte.')
                    : 'Activa tu ubicación para ver qué hay cerca.',
                style: TextStyle(color: fg, fontWeight: FontWeight.w600),
              ),
            ),
            TextButton(
              onPressed: loading
                  ? null
                  : () =>
                        ref.read(locationControllerProvider.notifier).request(),
              child: Text(loading ? 'Buscando…' : 'Activar'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Estado como etiqueta con ícono y color (no solo color), en vez de una oración.
class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final SyncStatus status;

  @override
  Widget build(BuildContext context) {
    final (icon, label, bg, fg) = switch (status) {
      SyncStatus.pending => (
        Icons.schedule,
        'Pendiente',
        AppTheme.sun,
        const Color(0xFF4A1F00),
      ),
      SyncStatus.sent => (
        Icons.check_circle_outline,
        'Enviada (demo)',
        AppTheme.mint,
        const Color(0xFF0B3D2E),
      ),
      SyncStatus.error => (
        Icons.error_outline,
        'Error · reintentar',
        const Color(0xFFFDE5E1),
        const Color(0xFF5C0F06),
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
