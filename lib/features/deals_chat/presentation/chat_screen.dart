import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di/providers.dart';
import '../../../core/result.dart';
import '../domain/chat.dart';

/// Chat del trato: escribir, frases rápidas y respuestas de ejemplo (claramente marcadas).
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.dealId});

  final String dealId;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _text = TextEditingController();

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _send(String text) async {
    final r = await ref.read(sendChatMessageProvider)(widget.dealId, text);
    if (!mounted) {
      return;
    }
    switch (r) {
      case Ok():
        _text.clear();
      case Err(:final failure):
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(failure.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = theme.colorScheme;
    final deal = ref
        .watch(dealsStreamProvider)
        .value
        ?.where((d) => d.id == widget.dealId)
        .firstOrNull;
    final messages =
        ref.watch(chatMessagesProvider(widget.dealId)).value ??
        const <ChatMessage>[];
    final online = ref.watch(onlineProvider).value ?? true;
    final name = deal?.providerName ?? 'Chat';
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: s.secondaryContainer,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Tu dirección exacta no se comparte en el chat. Las respuestas son de ejemplo.',
              style: TextStyle(
                color: s.onSecondaryContainer,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Escribe para coordinar con ${name.split(' ').first}.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                  )
                : ListView(
                    reverse: true,
                    padding: const EdgeInsets.all(12),
                    children: [
                      for (final m in messages.reversed) _Bubble(message: m),
                    ],
                  ),
          ),
          if (!online)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                'Sin internet: tu mensaje queda guardado en tu teléfono.',
                style: theme.textTheme.bodySmall,
              ),
            ),
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: quickPhrases.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) => ActionChip(
                label: Text(quickPhrases[i]),
                onPressed: () => _send(quickPhrases[i]),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _text,
                      maxLength: 300,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        hintText: 'Escribe un mensaje',
                        counterText: '',
                      ),
                      onSubmitted: _send,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    tooltip: 'Enviar mensaje',
                    iconSize: 28,
                    onPressed: () => _send(_text.text),
                    icon: const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    final me = message.fromMe;
    return Align(
      alignment: me ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.8,
        ),
        decoration: BoxDecoration(
          color: me ? s.primary : s.surfaceContainerLowest,
          border: me ? null : Border.all(color: s.outlineVariant),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(me ? 18 : 4),
            bottomRight: Radius.circular(me ? 4 : 18),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: me ? s.onPrimary : s.onSurface,
                fontSize: 16,
              ),
            ),
            if (message.isExample)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.science_outlined,
                      size: 14,
                      color: s.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Respuesta de ejemplo',
                      style: TextStyle(fontSize: 12, color: s.onSurfaceVariant),
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
