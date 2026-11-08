import 'package:go_router/go_router.dart';

import '../features/deals_chat/presentation/chat_screen.dart';
import '../features/deals_chat/presentation/messages_screen.dart';
import '../features/directory/presentation/profile_screen.dart';
import '../features/emergency/presentation/emergency_screen.dart';
import '../features/solidarity/presentation/neighbors_screen.dart';
import '../features/needs/presentation/home_screen.dart';
import '../features/proposals/presentation/need_detail_screen.dart';
import 'shell_scaffold.dart';

/// Rutas declarativas: las cinco pestañas del PWA (Inicio, Vecinos, Mensajes, Emergencia, Perfil).
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/chat/:dealId',
      builder: (_, state) =>
          ChatScreen(dealId: state.pathParameters['dealId']!),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => ShellScaffold(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (_, _) => const HomeScreen(),
              routes: [
                GoRoute(
                  path: 'need/:id',
                  builder: (_, state) =>
                      NeedDetailScreen(needId: state.pathParameters['id']!),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/vecinos',
              builder: (_, _) => const NeighborsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/mensajes',
              builder: (_, _) => const MessagesScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/emergencia',
              builder: (_, _) => const EmergencyScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/perfil', builder: (_, _) => const ProfileScreen()),
          ],
        ),
      ],
    ),
  ],
);
