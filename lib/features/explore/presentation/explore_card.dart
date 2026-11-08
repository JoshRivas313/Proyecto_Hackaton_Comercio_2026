import 'package:flutter/material.dart';

import '../../../app/widgets/example_badge.dart';

import '../../../app/theme/app_theme.dart';

import '../../../core/geo/geo_math.dart';
import '../../directory/domain/listing.dart';
import '../../needs/presentation/composer_sheet.dart';
import '../../needs/domain/need.dart';
import '../domain/explore_nearby.dart';

/// Tarjeta de un recurso cercano (servicio o producto) con Visto Bueno y acción.
class ExploreCard extends StatelessWidget {
  const ExploreCard({super.key, required this.item});

  final ExploreItem item;

  // (fondo, texto) por persona: identidad sin foto y sin inventar nada.
  static const _tints = [
    (AppTheme.coralSoft, AppTheme.onSun),
    (AppTheme.mint, AppTheme.onMint),
    (AppTheme.sky, AppTheme.onSky),
    (AppTheme.sun, AppTheme.onSun),
    (AppTheme.lilac, AppTheme.deepViolet),
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
                        : 'Lo recomiendan ${vb.example} vecinos'
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
