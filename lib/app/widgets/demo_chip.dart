import 'package:flutter/material.dart';

/// Un solo aviso de demostración en toda la app: una etiqueta pequeña que explica al tocarla
/// qué es real y qué es de ejemplo (así no se repite el mismo párrafo en cada pantalla).
class DemoChip extends StatelessWidget {
  const DemoChip({super.key});

  // Aviso retirado de la cabecera a pedido del equipo; el detalle vive en Perfil.
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

Future<void> showDemoInfo(BuildContext context) => showModalBottomSheet<void>(
  useRootNavigator: true,
  context: context,
  showDragHandle: true,
  builder: (ctx) {
    final theme = Theme.of(ctx);
    Widget line(IconData icon, String text) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: theme.textTheme.bodyLarge)),
        ],
      ),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cómo funciona hoy', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          line(
            Icons.check_circle_outline,
            'Es real: tu ubicación, el modo sin internet y el guardado en tu teléfono.',
          ),
          line(
            Icons.science_outlined,
            'Es de prueba: vecinos, precios, respuestas y números de emergencia.',
          ),
          line(
            Icons.cloud_off_outlined,
            'Aún no hay cuentas ni servidor: nada llega a otra persona.',
          ),
        ],
      ),
    );
  },
);
