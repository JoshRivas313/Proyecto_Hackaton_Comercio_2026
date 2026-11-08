import 'package:flutter/material.dart';

/// Etiqueta "Ejemplo": todo dato de demostración la lleva (ícono + texto, no solo color).
class ExampleBadge extends StatelessWidget {
  const ExampleBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    return Semantics(
      label: 'Dato de ejemplo',
      child: ExcludeSemantics(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: s.secondaryContainer,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.science_outlined,
                size: 14,
                color: s.onSecondaryContainer,
              ),
              const SizedBox(width: 4),
              Text(
                'Ejemplo',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: s.onSecondaryContainer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
