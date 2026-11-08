import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/empty_state.dart';
import '../../../app/widgets/example_badge.dart';
import '../../../app/widgets/motion.dart';
import '../../needs/domain/need.dart';
import '../../needs/presentation/composer_sheet.dart';
import '../domain/wall_demo.dart';
import 'market_sheets.dart';

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
    'Préstamo': (Icons.handyman_outlined, AppTheme.sky, AppTheme.onSky),
    'Trueque': (Icons.swap_horiz, AppTheme.sun, AppTheme.onSun),
    'Alquiler': (Icons.key_outlined, AppTheme.lilac, AppTheme.deepViolet),
    'Donación': (
      Icons.volunteer_activism_outlined,
      AppTheme.coralSoft,
      AppTheme.onSun,
    ),
    'Favor': (Icons.handshake_outlined, AppTheme.mint, AppTheme.onMint),
    'Intercambio de habilidades': (
      Icons.school_outlined,
      AppTheme.sun,
      AppTheme.onSun,
    ),
    'Movilidad solidaria': (
      Icons.directions_walk,
      AppTheme.sky,
      AppTheme.onSky,
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
          96,
        ),
        children: [
          Text('Entre vecinos', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 2),
          const Text('Pide ayuda, comparte o vende dentro de tu barrio'),
          const SizedBox(height: 10),
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: _BigAction(
                  color: AppTheme.coral,
                  textColor: AppTheme.onCoral,
                  icon: Icons.back_hand_outlined,
                  label: 'Necesito ayuda',
                  onTap: () => showComposer(context, kind: NeedKind.loan),
                ),
              ),
              Expanded(
                child: _BigAction(
                  color: AppTheme.brand,
                  textColor: Colors.white,
                  icon: Icons.handshake_outlined,
                  label: 'Quiero ayudar',
                  onTap: () => showWallOfferSheet(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _SellCard(onTap: () => showSellSheet(context)),
          const SizedBox(height: 10),
          const MyMarketSection(),
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 8,
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

/// Acción grande de Vecinos: coral para pedir, violeta para ayudar.
class _BigAction extends StatelessWidget {
  const _BigAction({
    required this.color,
    required this.textColor,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final Color color;
  final Color textColor;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 72),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Icon(icon, color: textColor, size: 28),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tercera acción principal: vender un producto (tarjeta horizontal de ancho completo).
class _SellCard extends StatelessWidget {
  const _SellCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      button: true,
      label: 'Vender un producto. Publica lo que quieres vender a tus vecinos.',
      child: ExcludeSemantics(
        child: Pressable(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.lilac,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.storefront_outlined,
                    color: AppTheme.brand,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vender un producto',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.deepViolet,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Publica y recibe ofertas de tus vecinos',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppTheme.deepViolet),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
