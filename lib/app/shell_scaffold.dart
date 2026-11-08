import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'di/providers.dart';
import 'widgets/offline_sheet.dart';

class ShellScaffold extends ConsumerWidget {
  const ShellScaffold({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final online = ref.watch(onlineProvider).value ?? true;
    final pending = ref.watch(pendingCountProvider);
    final fg = Theme.of(context).colorScheme.onSecondaryContainer;
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (i) =>
            shell.goBranch(i, initialLocation: i == shell.currentIndex),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(icon: Icon(Icons.swap_horiz), label: 'Vecinos'),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'Mensajes',
          ),
          NavigationDestination(
            icon: Icon(Icons.warning_amber_outlined),
            selectedIcon: Icon(Icons.warning),
            label: 'Emergencia',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
