import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../needs/domain/need.dart';
import '../domain/emergency.dart';
import 'call_button.dart';
import 'sos_sheet.dart';

/// Emergencia. Orden (regla inviolable 5): 1) instituciones oficiales, 2) pedir ayuda a vecinos.
class EmergencyScreen extends ConsumerWidget {
  const EmergencyScreen({super.key});

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
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => showSosSheet(context),
              icon: const Icon(Icons.sos),
              label: const Text('Necesito ayuda'),
            ),
            body: ListView(
              padding: EdgeInsets.fromLTRB(
                16,
                MediaQuery.paddingOf(context).top + 12,
                16,
                16,
              ),
              children: [
                // Cabecero rojo: modo emergencia claramente distinto del resto de la app.
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppTheme.emergencyRed, Color(0xFF8F1D10)],
                    ),
                  ),
                  child: const Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.warning_amber_rounded,
                          size: 34,
                          color: AppTheme.emergencyRed,
                        ),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Modo emergencia',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Primero la institución oficial. Después, tus vecinos.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  color: theme.colorScheme.errorContainer,
                  child: const Padding(
                    padding: EdgeInsets.all(14),
                    child: Text(
                      'Esta app no reemplaza a los servicios oficiales ni envía alertas reales todavía. En una urgencia grave, llama primero.',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '1. Llama primero a la institución',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'Números por verificar.',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                for (final c in officialContacts)
                  Card(
                    child: ListTile(
                      title: Text(c.name),
                      subtitle: Text(c.detail),
                      trailing: CallButton(name: c.name, phone: c.phone),
                    ),
                  ),
                const SizedBox(height: 16),
                Text(
                  '2. Pide ayuda a tu barrio',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                const Text('Toca el botón «Necesito ayuda».'),
                const SizedBox(height: 16),
                Text(
                  '3. Consejos generales',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
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
                  Card(
                    child: ListTile(
                      leading: Icon(t.$1, color: theme.colorScheme.primary),
                      title: Text(t.$2),
                    ),
                  ),
                Text(
                  'Son consejos generales: no reemplazan las indicaciones oficiales.',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 72),
                if (posts.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(
                    'Tus pedidos de ayuda',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  for (final p in posts)
                    Card(
                      child: ListTile(
                        leading: Icon(
                          p.isPrivate
                              ? Icons.lock_outline
                              : Icons.campaign_outlined,
                        ),
                        title: Text(p.type.label),
                        subtitle: Text('${p.why}\n${_status(p, isDemo)}'),
                        isThreeLine: true,
                      ),
                    ),
                ],
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
      SyncStatus.sent =>
        isDemo
            ? 'Enviado · barrio de ejemplo (demo) · ningún vecino real lo recibe'
            : 'Enviado',
      SyncStatus.error => 'No se pudo enviar · se reintentará',
    };
  }
}
