import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di/providers.dart';
import '../../../core/result.dart';
import '../../sync/presentation/sync_controller.dart';
import '../domain/emergency.dart';
import 'call_button.dart';

/// "Necesito ayuda": abrir → elegir situación → Enviar (3 toques).
/// "Qué pasó" viene prellenado con una plantilla: editarlo es opcional.
Future<void> showSosSheet(BuildContext context) => showModalBottomSheet<void>(
  useRootNavigator: true,
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => const SosSheet(),
);

class SosSheet extends ConsumerStatefulWidget {
  const SosSheet({super.key});

  @override
  ConsumerState<SosSheet> createState() => _SosSheetState();
}

class _SosSheetState extends ConsumerState<SosSheet> {
  EmergencyType? _type;
  final _why = TextEditingController();
  final _needs = <String>{};
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _why.dispose();
    super.dispose();
  }

  void _pick(EmergencyType t) => setState(() {
    _type = t;
    _why.text = t.template;
    _needs.clear();
    _error = null;
  });

  Future<void> _send() async {
    final type = _type;
    if (type == null) {
      return;
    }
    setState(() => _busy = true);
    final r = await ref.read(publishSosProvider)(
      type: type,
      why: _why.text,
      needs: _needs.toList(),
    );
    if (!mounted) {
      return;
    }
    switch (r) {
      case Ok():
        final messenger = ScaffoldMessenger.of(context);
        Navigator.of(context).pop();
        await ref.read(syncControllerProvider.notifier).flushNow();
        messenger.showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 8),
            content: Text(
              type.isPrivate
                  ? 'Guardado solo en tu teléfono. Esta versión NO avisa a nadie: llama a la institución.'
                  : 'Guardado. Esta versión no avisa a vecinos reales: si es grave, llama a la institución.',
            ),
          ),
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
    final t = _type;
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pedir ayuda', style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 4),
                  const Text('¿Qué situación es?'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final e in EmergencyType.values)
                        ChoiceChip(
                          label: Text(e.label),
                          selected: _type == e,
                          onSelected: (_) => _pick(e),
                        ),
                    ],
                  ),
                  if (t != null) ...[
                    const SizedBox(height: 16),
                    // 1.º: la institución oficial (regla inviolable 5).
                    Card(
                      color: theme.colorScheme.tertiaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Primero avisa a la institución',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(t.institution),
                            if (t.phone != null) ...[
                              const SizedBox(height: 8),
                              CallButton(name: t.institution, phone: t.phone!),
                            ] else
                              const Text(
                                'Llama a tu municipalidad o al centro de salud más cercano.',
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _why,
                      minLines: 2,
                      maxLines: 4,
                      maxLength: 200,
                      decoration: InputDecoration(
                        labelText: '¿Qué pasó? (puedes cambiar el texto)',
                        border: const OutlineInputBorder(),
                        errorText: _error,
                      ),
                      onChanged: (_) => setState(() => _error = null),
                    ),
                    const Text('¿Qué necesitas? (opcional)'),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        for (final n in t.needs)
                          FilterChip(
                            label: Text(n),
                            selected: _needs.contains(n),
                            onSelected: (v) => setState(
                              () => v ? _needs.add(n) : _needs.remove(n),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          t.isPrivate
                              ? 'Caso sensible: no aparece en ningún muro y se queda solo en tu teléfono. '
                                    'Esta versión NO avisa a nadie. Si estás en peligro, llama ahora.'
                              : 'Esta versión es una demostración: tu pedido se guarda y se envía al "barrio de ejemplo", '
                                    'pero ningún vecino real lo recibe. Tu ubicación exacta no se comparte.',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: (t == null || _busy || _why.text.trim().length < 3)
                  ? null
                  : _send,
              child: Text(
                _busy
                    ? 'Guardando…'
                    : (t?.isPrivate ?? false)
                    ? 'Guardar en mi teléfono'
                    : 'Guardar pedido de ayuda',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
