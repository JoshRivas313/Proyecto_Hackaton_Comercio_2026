import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/di/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/empty_state.dart';
import '../../proposals/domain/deal.dart';
import '../domain/chat.dart';
import '../domain/chat_format.dart';

enum _Filter { all, awaiting }

/// Mensajes: una conversación por cada trato, ordenadas por el último mensaje.
class MessagesScreen extends ConsumerStatefulWidget {
  const MessagesScreen({super.key});

  @override
  ConsumerState<MessagesScreen> createState() => _MessagesScreenState();
}

class _Row {
  _Row(this.deal, this.messages, this.unread, this.needText);

  final Deal deal;
  final List<ChatMessage> messages;
  final int unread;
  final String? needText;

  ChatMessage? get last => messages.isEmpty ? null : messages.last;
  DateTime get when => last?.createdAt ?? deal.acceptedAt;
}

class _MessagesScreenState extends ConsumerState<MessagesScreen> {
  _Filter _filter = _Filter.all;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deals = ref.watch(dealsStreamProvider).value ?? const <Deal>[];
    final all =
        ref.watch(allChatMessagesProvider).value ?? const <ChatMessage>[];
    final reads =
        ref.watch(chatReadsProvider).value ?? const <String, DateTime>{};
    final needs = ref.watch(needsStreamProvider).value ?? const [];
    final now = DateTime.now();

    final rows = [
      for (final d in deals)
        () {
          final mine = all.where((m) => m.dealId == d.id).toList();
          final need = needs.where((n) => n.id == d.needId).firstOrNull;
          return _Row(d, mine, unreadCount(mine, reads[d.id]), need?.text);
        }(),
    ]..sort((a, b) => b.when.compareTo(a.when));

    final shown = _filter == _Filter.all
        ? rows
        : rows.where((r) => awaitingMyReply(r.messages)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Mensajes')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Row(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Todas'),
                  selected: _filter == _Filter.all,
                  onSelected: (_) => setState(() => _filter = _Filter.all),
                ),
                ChoiceChip(
                  label: const Text('Sin responder'),
                  selected: _filter == _Filter.awaiting,
                  onSelected: (_) => setState(() => _filter = _Filter.awaiting),
                ),
              ],
            ),
          ),
          Expanded(
            child: shown.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: EmptyState(
                      icon: Icons.chat_bubble_outline,
                      title: rows.isEmpty
                          ? 'Aún no tienes conversaciones'
                          : 'Nada por responder',
                      message: rows.isEmpty
                          ? 'Se abren cuando aceptas una propuesta.'
                          : 'Todas tus conversaciones están al día.',
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: shown.length,
                    separatorBuilder: (_, _) => Divider(
                      height: 1,
                      indent: 84,
                      color: theme.colorScheme.outlineVariant,
                    ),
                    itemBuilder: (context, i) =>
                        _ConversationTile(row: shown[i], now: now),
                  ),
          ),
        ],
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({required this.row, required this.now});

  final _Row row;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = theme.colorScheme;
    final d = row.deal;
    final last = row.last;
    final unread = row.unread > 0;
    final initials = d.providerName
        .split(' ')
        .where((w) => w.isNotEmpty)
        .map((w) => w[0])
        .take(2)
        .join();
    return InkWell(
      onTap: () => context.push('/chat/${d.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: s.primaryContainer,
              child: Text(
                initials,
                style: TextStyle(
                  color: s.onPrimaryContainer,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          d.providerName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: unread
                                ? FontWeight.w800
                                : FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        listTime(row.when, now),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: unread ? s.primary : s.onSurfaceVariant,
                          fontWeight: unread ? FontWeight.w800 : null,
                        ),
                      ),
                    ],
                  ),
                  if (row.needText != null)
                    Text(
                      row.needText!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: s.primary,
                      ),
                    ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          last == null
                              ? 'Escribe para coordinar'
                              : '${last.fromMe ? 'Tú: ' : ''}${last.text}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: unread ? FontWeight.w700 : null,
                            color: unread ? s.onSurface : s.onSurfaceVariant,
                          ),
                        ),
                      ),
                      if (unread)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          constraints: const BoxConstraints(minWidth: 22),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.brand,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '${row.unread}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
