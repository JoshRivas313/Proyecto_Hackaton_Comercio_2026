import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Pantalla de "Sin conexión": qué sigue funcionando y cuántas cosas esperan para enviarse.
Future<void> showOfflineInfo(
  BuildContext context,
  int pending,
) => showModalBottomSheet<void>(
  useRootNavigator: true,
  context: context,
  showDragHandle: true,
  builder: (ctx) {
    final theme = Theme.of(ctx);
    Widget ok(String text) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppTheme.confirmed),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: theme.textTheme.bodyLarge)),
        ],
      ),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                Icons.cloud_off_outlined,
                size: 44,
                color: theme.colorScheme.onSecondaryContainer,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'Sin conexión a internet',
              style: theme.textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              'Puedes seguir usando la app.',
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 14),
          ok('Ver lo que ya tienes guardado'),
          ok('Ver los contactos de emergencia'),
          ok('Crear nuevas solicitudes'),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.sun,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                const Icon(Icons.schedule, color: AppTheme.onSun),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    pending == 0
                        ? 'No tienes nada pendiente de enviar.'
                        : pending == 1
                        ? '1 cosa pendiente de enviar. Se enviará sola al volver la conexión.'
                        : '$pending cosas pendientes de enviar. Se enviarán solas al volver la conexión.',
                    style: const TextStyle(
                      color: AppTheme.onSun,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  },
);
