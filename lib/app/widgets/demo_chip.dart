import 'package:flutter/material.dart';

/// Un solo aviso de demostración en toda la app: una etiqueta pequeña que explica al tocarla
/// qué es real y qué es de ejemplo (así no se repite el mismo párrafo en cada pantalla).
class DemoChip extends StatelessWidget {
  const DemoChip({super.key});

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: 'Modo demostración. Toca para saber qué es real y qué es de ejemplo',
    child: ExcludeSemantics(
      child: ActionChip(
        avatar: const Icon(Icons.science_outlined, size: 18),
        label: const Text('Demo'),
        onPressed: () => showDemoInfo(context),
      ),
    ),
  );
}

Future<void> showDemoInfo(BuildContext context) => showModalBottomSheet<void>(
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
          Text('Versión de demostración', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          line(
            Icons.check_circle_outline,
            'Es real: tu ubicación, el modo sin internet y el guardado en tu teléfono.',
          ),
          line(
            Icons.science_outlined,
            'Es de ejemplo: vecinos, precios, respuestas y números de emergencia.',
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
