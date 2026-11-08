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
            appBar: AppBar(
              title: const Text('Emergencia'),
              backgroundColor: theme.colorScheme.errorContainer,
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => showSosSheet(context),
              icon: const Icon(Icons.sos),
              label: const Text('Necesito ayuda'),
            ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  color: theme.colorScheme.errorContainer,
                  child: const Padding(
                    padding: EdgeInsets.all(14),
                    child: Text(
                      'Esta app no reemplaza a los servicios oficiales. En una urgencia grave, llama primero '
                      'a la institución. Esta es una versión de demostración: todavía no avisa a vecinos reales.',
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
                  'Números por verificar antes de la presentación.',
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
                const Text(
                  'Usa el botón rojo «Necesito ayuda», siempre visible abajo: eliges la situación y lo guardas.',
                ),
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
