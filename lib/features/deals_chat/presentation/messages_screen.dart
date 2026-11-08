import 'package:flutter/material.dart';

/// Mensajes: el chat del trato llega con las cuentas (mobile-mejoras). Hoy lo decimos con claridad.
class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Mensajes')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 64,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                'Aún no tienes conversaciones',
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Cuando aceptes una propuesta de una persona real, aquí podrás escribirle para coordinar. '
                'Todavía no hay cuentas, así que no inventamos conversaciones de ejemplo.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
