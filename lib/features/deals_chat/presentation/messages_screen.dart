import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/di/providers.dart';
import '../../../app/widgets/empty_state.dart';

/// Mensajes: una conversación por cada trato (se abre al aceptar una propuesta).
class MessagesScreen extends ConsumerWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final deals = ref.watch(dealsStreamProvider).value ?? const [];
    final all = ref.watch(allChatMessagesProvider).value ?? const [];
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          16,
          MediaQuery.paddingOf(context).top + 12,
          16,
          16,
        ),
        children: [
          Text('Mensajes', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          if (deals.isEmpty)
            const EmptyState(
              icon: Icons.chat_bubble_outline,
              title: 'Aún no tienes conversaciones',
              message: 'Se abren cuando aceptas una propuesta.',
            )
          else
            for (final d in deals)
              Builder(
                builder: (context) {
                  final mine = all.where((m) => m.dealId == d.id).toList();
                  final last = mine.isEmpty ? null : mine.last;
                  final initials = d.providerName
                      .split(' ')
                      .where((w) => w.isNotEmpty)
                      .map((w) => w[0])
                      .take(2)
                      .join();
                  return Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      leading: CircleAvatar(
                        radius: 26,
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Text(
                          initials,
                          style: TextStyle(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      title: Text(
                        d.providerName,
                        style: theme.textTheme.titleMedium,
                      ),
                      subtitle: Text(
                        last == null
                            ? 'Escribe para coordinar'
                            : '${last.fromMe ? 'Tú: ' : ''}${last.text}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('/chat/${d.id}'),
                    ),
                  );
                },
              ),
        ],
      ),
    );
  }
}
