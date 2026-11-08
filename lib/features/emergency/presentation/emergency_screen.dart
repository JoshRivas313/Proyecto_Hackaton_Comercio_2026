import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../needs/domain/need.dart';
import '../../needs/presentation/composer_sheet.dart';
import '../../solidarity/presentation/market_sheets.dart';
import '../domain/emergency.dart';
import 'call_button.dart';
import 'sos_sheet.dart';

/// Emergencias. Orden (regla inviolable 5): 1) institución oficial, 2) apoyo de vecinos.
/// Rojo solo para lo crítico; verde para la colaboración. Esta versión NO envía alertas reales.
class EmergencyScreen extends ConsumerWidget {
  const EmergencyScreen({super.key});

  static const _ink = Color(0xFF30283B);
  static const _redSoft = Color(0xFFFCE6E3);
  static const _greenSoft = Color(0xFFE3F4EF);

  static IconData _iconFor(String phone) => switch (phone) {
    '105' => Icons.local_police_outlined,
    '116' => Icons.fire_truck_outlined,
    '106' => Icons.medical_services_outlined,
    '115' => Icons.warning_amber_rounded,
    _ => Icons.support_agent_outlined,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts =
        ref.watch(emergencyPostsStreamProvider).value ??
        const <EmergencyPost>[];
    final isDemo = ref.watch(syncGatewayProvider).isDemo;
    return Theme(
      data: AppTheme.emergency(),
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          return Scaffold(
            backgroundColor: AppTheme.cream,
            body: ListView(
              padding: EdgeInsets.fromLTRB(
                16,
                MediaQuery.paddingOf(context).top + 12,
                16,
                96,
              ),
              children: [
                // Cabecera compacta con iconografía de seguridad.
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: _redSoft,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        color: AppTheme.emergencyRed,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Emergencias',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: _ink,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Advertencia breve y siempre visible.
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _redSoft,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: AppTheme.emergencyRed,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Ante una urgencia grave, llama primero a la institución oficial. '
                          'Esta app aún no envía alertas reales.',
                          style: TextStyle(
                            color: _ink,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                _SosCard(onTap: () => showSosSheet(context)),
                const SizedBox(height: 24),
                const _SectionTitle(
                  icon: Icons.local_police_outlined,
                  color: AppTheme.emergencyRed,
                  title: 'Atención oficial',
                  subtitle: 'Llama primero. Números por verificar.',
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      for (final (i, c) in officialContacts.indexed) ...[
                        if (i > 0)
                          Divider(
                            height: 1,
                            indent: 64,
                            color: theme.colorScheme.outlineVariant,
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: _redSoft,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _iconFor(c.phone),
                                  color: AppTheme.emergencyRed,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      c.name,
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(color: _ink),
                                    ),
                                    Text(
                                      c.detail,
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              CallButton(
                                name: c.name,
                                phone: c.phone,
                                compact: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Apoyo comunitario: sección verde, distinta de lo oficial.
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _greenSoft,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SectionTitle(
                        icon: Icons.diversity_3_outlined,
                        color: AppTheme.confirmed,
                        title: 'Apoyo comunitario',
                        subtitle: 'Coordina ayuda con tus vecinos. No reemplaza a las autoridades.',
                      ),
                      const SizedBox(height: 12),
                      Row(
                        spacing: 10,
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: AppTheme.confirmed,
                                foregroundColor: Colors.white,
                                minimumSize: const Size.fromHeight(52),
                              ),
                              onPressed: () =>
                                  showComposer(context, kind: NeedKind.help),
                              icon: const Icon(Icons.back_hand_outlined),
                              label: const Text('Pedir apoyo'),
                            ),
                          ),
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.confirmed,
                                backgroundColor: Colors.white,
                                side: BorderSide.none,
                                minimumSize: const Size.fromHeight(52),
                              ),
                              onPressed: () => showWallOfferSheet(context),
                              icon: const Icon(Icons.handshake_outlined),
                              label: const Text('Ofrecer recursos'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (posts.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    'Tus pedidos de ayuda',
                    style: theme.textTheme.titleLarge?.copyWith(color: _ink),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        for (final p in posts)
                          ListTile(
                            leading: Icon(
                              p.isPrivate
                                  ? Icons.lock_outline
                                  : Icons.campaign_outlined,
                            ),
                            title: Text(p.type.label),
                            subtitle: Text('${p.why}\n${_status(p, isDemo)}'),
                            isThreeLine: true,
                          ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                // Consejos al final, plegados.
                Theme(
                  data: theme.copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    title: Text(
                      'Consejos generales',
                      style: theme.textTheme.titleMedium?.copyWith(color: _ink),
                    ),
                    children: [
                      for (final t in const [
                        (
                          Icons.self_improvement,
                          'Mantén la calma y busca un lugar seguro, lejos de vidrios y objetos que puedan caer.',
                        ),
                        (
                          Icons.record_voice_over_outlined,
                          'Sigue las indicaciones de las autoridades y de Defensa Civil.',
                        ),
                        (
                          Icons.diversity_3_outlined,
                          'Ayuda a quien lo necesite sin ponerte en riesgo y avisa a tus vecinos.',
                        ),
                      ])
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(t.$1, color: AppTheme.confirmed),
                          title: Text(t.$2),
                        ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Son consejos generales: no reemplazan las indicaciones oficiales.',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static String _status(EmergencyPost p, bool isDemo) {
    if (p.isPrivate) {
      return 'Solo en tu teléfono · esta versión no avisa a nadie';
    }
    return switch (p.syncStatus) {
      SyncStatus.pending =>
        'Guardado en tu teléfono · se enviará cuando haya internet',
      SyncStatus.sent => 'Enviado',
      SyncStatus.error => 'No se pudo enviar · se reintentará',
    };
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 26),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: EmergencyScreen._ink,
                ),
              ),
              Text(subtitle, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

/// «Necesito ayuda»: acción destacada. Solo abre la hoja (no marca ni avisa por sí sola).
class _SosCard extends StatelessWidget {
  const _SosCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Necesito ayuda. Guarda tu pedido en tu teléfono. No avisa a nadie todavía.',
      child: ExcludeSemantics(
        child: Material(
          color: AppTheme.emergencyRed,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.sos,
                      color: AppTheme.emergencyRed,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Necesito ayuda',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Guarda tu pedido en tu teléfono. Todavía no avisa a nadie: '
                          'llama primero a la institución.',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
