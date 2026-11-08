import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/theme/app_theme.dart';

/// Botón de llamada con confirmación: los números están POR VERIFICAR y no se marcan al primer toque.
class CallButton extends StatelessWidget {
  const CallButton({
    super.key,
    required this.name,
    required this.phone,
    this.compact = false,
  });

  /// Versión corta para filas: solo el número, en rojo suave.
  final bool compact;

  final String name;
  final String phone;

  Future<void> _confirmAndCall(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Llamar al $phone'),
        content: Text(
          '$name.\n\nOjo: este número está por verificar con fuentes oficiales. '
          'Si no es el correcto, marca el número oficial vigente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Llamar'),
          ),
        ],
      ),
    );
    if (ok != true) {
      return;
    }
    final launched = await launchUrl(Uri(scheme: 'tel', path: phone));
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No se pudo abrir el teléfono. Marca el $phone manualmente.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => compact
      ? FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: AppTheme.redSoft,
            foregroundColor: AppTheme.emergencyRed,
            minimumSize: const Size(88, 48),
          ),
          onPressed: () => _confirmAndCall(context),
          icon: const Icon(Icons.call, size: 20),
          label: Text(
            phone,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
        )
      : OutlinedButton.icon(
          onPressed: () => _confirmAndCall(context),
          icon: const Icon(Icons.call),
          label: Text('Llamar $phone'),
        );
}
