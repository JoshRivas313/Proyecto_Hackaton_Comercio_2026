import 'package:flutter/widgets.dart';

/// Etiqueta de dato de ejemplo. Retirada de la interfaz a pedido del equipo:
/// la app ya no muestra la palabra «Ejemplo» en cada tarjeta.
class ExampleBadge extends StatelessWidget {
  const ExampleBadge({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
