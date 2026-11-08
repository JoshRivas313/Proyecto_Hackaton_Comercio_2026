import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/empty_state.dart';
import '../../../app/widgets/example_badge.dart';
import '../../../app/widgets/motion.dart';
import '../../needs/domain/need.dart';
import '../../needs/presentation/composer_sheet.dart';
import '../domain/wall_demo.dart';

/// Vecinos: muro de pedidos y ofertas sin dinero (economía solidaria). Contenido de ejemplo.
class NeighborsScreen extends StatefulWidget {
  const NeighborsScreen({super.key});

  @override
  State<NeighborsScreen> createState() => _NeighborsScreenState();
}

class _NeighborsScreenState extends State<NeighborsScreen> {
  bool _requests = true;
  String _mode = 'Todas';

  // Ícono y colores por modalidad (texto oscuro sobre fondo suave: contraste AA).
  static const _modeStyle = <String, (IconData, Color, Color)>{
    'Préstamo': (Icons.handyman_outlined, AppTheme.sky, Color(0xFF12304D)),
    'Trueque': (Icons.swap_horiz, AppTheme.sun, Color(0xFF4A1F00)),
    'Alquiler': (Icons.key_outlined, Color(0xFFE9E3FF), Color(0xFF3B2790)),
    'Donación': (
      Icons.volunteer_activism_outlined,
      AppTheme.coralSoft,
      Color(0xFF4A1F00),
    ),
    'Favor': (Icons.handshake_outlined, AppTheme.mint, Color(0xFF0B3D2E)),
    'Intercambio de habilidades': (
      Icons.school_outlined,
      AppTheme.sun,
      Color(0xFF4A1F00),
    ),
    'Movilidad solidaria': (
      Icons.directions_walk,
      AppTheme.sky,
      Color(0xFF12304D),
    ),
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final src = _requests ? demoWallRequests : demoWallOffers;
    final list = src.where((i) => _mode == 'Todas' || i.mode == _mode).toList();
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          16,
          MediaQuery.paddingOf(context).top + 12,
          16,
          24,
        ),
        children: [
          // Encabezado acogedor: comunidad, no marketplace.
          FadeSlideIn(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.coralSoft,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppTheme.coral,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(
                          Icons.diversity_3_rounded,
                          color: Color(0xFF2A1670),
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Entre vecinos',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: const Color(0xFF4A1F00),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Pide o ofrece ayuda sin dinero: préstamos, trueques, favores y donaciones. '
                    'Lo que ves es de ejemplo: todavía no hay cuentas para compartir entre vecinos.',
                    style: TextStyle(color: Color(0xFF4A1F00), height: 1.35),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.coral,
                        foregroundColor: const Color(0xFF2A1670),
                      ),
                      onPressed: () =>
                          showComposer(context, kind: NeedKind.loan),
                      icon: const Icon(Icons.add_circle_outline),
                      label: const Text('Pedir algo a un vecino'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(
                value: true,
                label: Text('Pedidos'),
                icon: Icon(Icons.pan_tool_alt_outlined),
              ),
              ButtonSegment(
                value: false,
                label: Text('Ofertas'),
                icon: Icon(Icons.card_giftcard_outlined),
              ),
            ],
            selected: {_requests},
            onSelectionChanged: (s) => setState(() => _requests = s.first),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              ChoiceChip(
                label: const Text('Todas'),
                selected: _mode == 'Todas',
                onSelected: (_) => setState(() => _mode = 'Todas'),
              ),
              for (final m in wallModes)
                ChoiceChip(
                  avatar: Icon(_modeStyle[m]!.$1, size: 18),
                  label: Text(m),
                  selected: _mode == m,
                  onSelected: (_) => setState(() => _mode = m),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _requests ? 'Pedidos de tus vecinos' : 'Ofertas de tus vecinos',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          if (list.isEmpty)
            const EmptyState(
              icon: Icons.volunteer_activism_outlined,
              title: 'Aquí aún no hay nada',
              message: 'No hay publicaciones con esta modalidad por ahora. Sé el primero en pedir o ofrecer.',
            )
          else
            for (final (i, item) in list.indexed)
              FadeSlideIn(
                key: ValueKey('${_requests}_${_mode}_$i'),
                delayMs: 50 * i,
                child: _WallCard(item: item, style: _modeStyle[item.mode]!),
              ),
        ],
      ),
    );
  }
}

class _WallCard extends StatelessWidget {
  const _WallCard({required this.item, required this.style});

  final WallItem item;
  final (IconData, Color, Color) style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: style.$2,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(style.$1, color: style.$3, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.who, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(item.text),
                  const SizedBox(height: 6),
                  Text(
                    '${item.mode} · ${item.distance}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const ExampleBadge(),
          ],
        ),
      ),
    );
  }
}
