import 'package:flutter/material.dart';

const _slides = [
  (
    Icons.edit_note,
    'Cuéntanos qué necesitas',
    'Eliges una frase o escribes, y publicas. Son 3 toques como máximo.',
  ),
  (
    Icons.groups_2_outlined,
    'Tu barrio propone',
    'Vecinos y negocios cercanos responden con precio, distancia y disponibilidad. Tú eliges.',
  ),
  (
    Icons.verified_outlined,
    'Nos encontramos con un código',
    'Al aceptar, recibes un código de 4 dígitos. Sirve para confirmar que se encontraron de verdad. Después se califican.',
  ),
  (
    Icons.warning_amber_rounded,
    'Y si hay una emergencia',
    'Primero llama a la institución oficial. Después pides ayuda a tus vecinos. Tu ubicación exacta nunca es pública.',
  ),
];

/// Tutorial (requisito 3): 4 pasos cortos, se puede cerrar en cualquier momento.
Future<void> showTutorial(BuildContext context) => showModalBottomSheet<void>(
  useRootNavigator: true,
  context: context,
  showDragHandle: true,
  isScrollControlled: true,
  builder: (_) => const _Tutorial(),
);

class _Tutorial extends StatefulWidget {
  const _Tutorial();

  @override
  State<_Tutorial> createState() => _TutorialState();
}

class _TutorialState extends State<_Tutorial> {
  int _i = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = _slides[_i];
    final last = _i == _slides.length - 1;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(s.$1, size: 72, color: theme.colorScheme.primary),
          const SizedBox(height: 12),
          Semantics(
            liveRegion: true,
            child: Text(
              '${_i + 1} de ${_slides.length}: ${s.$2}',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            s.$3,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              if (_i > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _i--),
                    child: const Text('Atrás'),
                  ),
                ),
              if (_i > 0) const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () =>
                      last ? Navigator.of(context).pop() : setState(() => _i++),
                  child: Text(last ? 'Listo' : 'Siguiente'),
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Saltar'),
          ),
        ],
      ),
    );
  }
}
