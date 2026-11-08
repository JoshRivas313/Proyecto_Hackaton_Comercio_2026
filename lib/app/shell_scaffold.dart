import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'di/providers.dart';
import 'theme/app_theme.dart';
import 'widgets/offline_sheet.dart';

/// Pestañas: 0 Inicio · 1 Vecinos · 2 Mapa (central) · 3 Emergencia · 4 Perfil.
class ShellScaffold extends ConsumerWidget {
  const ShellScaffold({super.key, required this.shell});

  final StatefulNavigationShell shell;

  static const _emergencyIndex = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final online = ref.watch(onlineProvider).value ?? true;
    final pending = ref.watch(pendingCountProvider);
    final fg = Theme.of(context).colorScheme.onSecondaryContainer;
    // Mensajes (FAB) se oculta en Emergencia (no estorba al SOS) y cuando aparece el teclado.
    final showMessagesFab =
        shell.currentIndex != _emergencyIndex &&
        MediaQuery.viewInsetsOf(context).bottom == 0;
    return Scaffold(
      body: Column(
        children: [
          if (!online)
            Semantics(
              liveRegion: true,
              button: true,
              label: pending == 0
                  ? 'Sin internet. Toca para ver qué puedes hacer.'
                  : 'Sin internet. $pending pendientes de enviar. Toca para ver detalles.',
              child: ExcludeSemantics(
                child: Material(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: InkWell(
                    onTap: () => showOfflineInfo(context, pending),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        16,
                        MediaQuery.paddingOf(context).top + 8,
                        12,
                        8,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.cloud_off_outlined, color: fg),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              pending == 0
                                  ? 'Sin internet. Sigues usando la app.'
                                  : 'Sin internet · $pending pendiente${pending == 1 ? '' : 's'} de enviar',
                              style: TextStyle(
                                color: fg,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Text(
                            'Ver',
                            style: TextStyle(
                              color: fg,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Icon(Icons.chevron_right, color: fg),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          Expanded(child: shell),
        ],
      ),
      floatingActionButton: showMessagesFab
          ? ListenableBuilder(
              // Solo en las pantallas raíz de cada pestaña: nunca sobre formularios ni detalles.
              listenable: GoRouter.of(context).routeInformationProvider,
              builder: (context, _) {
                final path = GoRouter.of(context)
                    .routeInformationProvider
                    .value
                    .uri
                    .path;
                const roots = {'/', '/vecinos', '/mapa', '/perfil'};
                if (!roots.contains(path)) {
                  return const SizedBox.shrink();
                }
                final unread = ref.watch(unreadTotalProvider);
                return Badge(
                  isLabelVisible: unread > 0,
                  label: Text('$unread'),
                  backgroundColor: AppTheme.coral,
                  textColor: AppTheme.onCoral,
                  child: FloatingActionButton(
                    heroTag: 'fab-mensajes',
                    tooltip: unread > 0
                        ? 'Mensajes, $unread sin leer'
                        : 'Mensajes',
                    shape: const CircleBorder(),
                    backgroundColor: AppTheme.brand,
                    foregroundColor: Colors.white,
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      context.push('/mensajes');
                    },
                    child: const Icon(Icons.chat_bubble_rounded),
                  ),
                );
              },
            )
          : null,
      bottomNavigationBar: _BottomBar(
        current: shell.currentIndex,
        onTap: (i) =>
            shell.goBranch(i, initialLocation: i == shell.currentIndex),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.current, required this.onTap});

  final int current;
  final ValueChanged<int> onTap;

  static const _barHeight = 72.0;
  static const _lift =
      28.0; // cuánto sobresale el círculo (queda DENTRO del área táctil)

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      child: SizedBox(
        height: _barHeight + _lift,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: _barHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: s.surfaceContainerLowest,
                  boxShadow: const [
                    BoxShadow(
                      color: AppTheme.shadowNav,
                      blurRadius: 18,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _Item(
                      index: 0,
                      current: current,
                      label: 'Inicio',
                      icon: Icons.home_outlined,
                      active: Icons.home,
                      onTap: onTap,
                    ),
                    _Item(
                      index: 1,
                      current: current,
                      label: 'Vecinos',
                      icon: Icons.swap_horiz,
                      active: Icons.swap_horiz,
                      onTap: onTap,
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            'Mapa',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: current == 2
                                  ? AppTheme.brand
                                  : s.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ),
                    _Item(
                      index: 3,
                      current: current,
                      label: 'Emergencia',
                      icon: Icons.warning_amber_outlined,
                      active: Icons.warning,
                      onTap: onTap,
                    ),
                    _Item(
                      index: 4,
                      current: current,
                      label: 'Perfil',
                      icon: Icons.person_outline,
                      active: Icons.person,
                      onTap: onTap,
                    ),
                  ],
                ),
              ),
            ),
            // Botón central: círculo violeta elevado, dentro del área táctil de la barra.
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Semantics(
                  button: true,
                  selected: current == 2,
                  label: 'Mapa. Explorar cerca',
                  child: ExcludeSemantics(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        onTap(2);
                      },
                      child: AnimatedScale(
                        scale: current == 2 ? 1.08 : 1,
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOutBack,
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppTheme.brand,
                            shape: BoxShape.circle,
                            border: Border.all(color: s.surface, width: 4),
                            boxShadow: const [
                              BoxShadow(
                                color: AppTheme.shadowBrand,
                                blurRadius: 14,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.explore_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.index,
    required this.current,
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final int index;
  final int current;
  final String label;
  final IconData icon;
  final IconData active;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    final selected = index == current;
    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: ExcludeSemantics(
          child: InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              onTap(index);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: selected ? s.primaryContainer : Colors.transparent,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Icon(
                    selected ? active : icon,
                    color: selected ? s.onPrimaryContainer : s.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: s.onSurface,
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
