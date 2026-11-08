import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/result.dart';
import '../domain/post_response.dart';
import '../domain/wall_demo.dart';

/// Formulario de respuesta adaptado al tipo de publicación. La publicación original queda
/// visible arriba mientras se responde.
Future<void> showRespondSheet(
  BuildContext context,
  WallItem item,
  PostKind kind,
) => showModalBottomSheet<void>(
  useRootNavigator: true,
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => _RespondSheet(item: item, kind: kind),
);

/// Consulta del estado de una propuesta ya enviada.
Future<void> showResponseStatus(
  BuildContext context,
  WallItem item,
  PostResponse r,
) => showModalBottomSheet<void>(
  useRootNavigator: true,
  context: context,
  showDragHandle: true,
  builder: (_) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Propuesta enviada',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 4),
        Text('${item.who}: ${item.text}'),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.lilac,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            r.summary.isEmpty ? actionLabel(r.kind) : r.summary,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 10),
        const Row(
          children: [
            Icon(Icons.schedule, size: 18),
            SizedBox(width: 6),
            Expanded(
              child: Text('Estado: enviada, esperando la respuesta del autor.'),
            ),
          ],
        ),
      ],
    ),
  ),
);

class _RespondSheet extends ConsumerStatefulWidget {
  const _RespondSheet({required this.item, required this.kind});

  final WallItem item;
  final PostKind kind;

  @override
  ConsumerState<_RespondSheet> createState() => _RespondSheetState();
}

class _RespondSheetState extends ConsumerState<_RespondSheet> {
  late final Map<ResponseField, TextEditingController> _c = {
    for (final f in fieldsFor(widget.kind)) f: TextEditingController(),
  };
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    for (final c in _c.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _send() async {
    if (_busy) return; // evita envíos duplicados por doble toque
    setState(() {
      _busy = true;
      _error = null;
    });
    final r = await ref.read(sendPostResponseProvider)(
      widget.item,
      widget.kind,
      {for (final e in _c.entries) e.key: e.value.text},
    );
    if (!mounted) return;
    switch (r) {
      case Ok():
        final messenger = ScaffoldMessenger.of(context);
        Navigator.of(context).pop();
        messenger.showSnackBar(
          const SnackBar(content: Text('Propuesta enviada')),
        );
      case Err(:final failure):
        setState(() {
          _busy = false;
          _error = failure.message;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final required = requiredFor(widget.kind);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        0,
        16,
        16 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    actionLabel(widget.kind),
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  // La publicación original queda a la vista.
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.lilac,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.item.who,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppTheme.deepViolet,
                          ),
                        ),
                        Text(widget.item.text),
                        Text(
                          '${widget.item.mode} · a ${widget.item.distance}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (final f in fieldsFor(widget.kind))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: TextField(
                        controller: _c[f],
                        keyboardType:
                            f == ResponseField.price ||
                                f == ResponseField.quantity
                            ? TextInputType.number
                            : TextInputType.text,
                        inputFormatters: f == ResponseField.price
                            ? [FilteringTextInputFormatter.digitsOnly]
                            : null,
                        minLines: f == ResponseField.message ? 2 : 1,
                        maxLines: f == ResponseField.message ? 3 : 1,
                        maxLength: f == ResponseField.message ? 160 : 80,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          labelText:
                              '${fieldLabel(f)}${required.contains(f) || f == ResponseField.message ? '' : ' (opcional)'}',
                          hintText: fieldHint(f),
                          counterText: '',
                          prefixText: f == ResponseField.price ? 'S/ ' : null,
                        ),
                        onChanged: (_) => setState(() => _error = null),
                      ),
                    ),
                  if (_error != null)
                    Text(
                      _error!,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  if (widget.kind == PostKind.emergency)
                    Text(
                      'Esto no envía alertas reales: registra tu apoyo disponible.',
                      style: theme.textTheme.bodySmall,
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _busy ? null : _send,
              child: Text(_busy ? 'Enviando…' : actionLabel(widget.kind)),
            ),
          ),
        ],
      ),
    );
  }
}
