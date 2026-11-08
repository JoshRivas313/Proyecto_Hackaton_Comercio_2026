import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/di/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/result.dart';
import '../../sync/presentation/sync_controller.dart';
import '../domain/need.dart';
import 'more_details.dart';
import 'need_labels.dart';
import '../../../core/log.dart';

/// Abre el formulario de "¿Qué necesitas?".
///
/// Pensado para ≤ 3 toques: abrir → elegir una frase (fija tipo y texto) → Publicar.
/// Con texto propio: abrir → tocar el campo → Publicar (el tipo por defecto es Servicio).
Future<void> showComposer(
  BuildContext context, {
  NeedKind? kind,
  String? text,
  String? categoryId,
}) {
  return showModalBottomSheet<void>(
    useRootNavigator: true,
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => ComposerSheet(
      initialKind: kind,
      initialText: text,
      categoryId: categoryId,
    ),
  );
}

class ComposerSheet extends ConsumerStatefulWidget {
  const ComposerSheet({
    super.key,
    this.initialKind,
    this.initialText,
    this.categoryId,
  });

  /// Categoría elegida en Inicio; se guarda en la solicitud.
  final String? categoryId;

  final NeedKind? initialKind;
  final String? initialText;

  @override
  ConsumerState<ComposerSheet> createState() => _ComposerSheetState();
}

class _ComposerSheetState extends ConsumerState<ComposerSheet> {
  late NeedKind _kind = widget.initialKind ?? NeedKind.service;
  Urgency _urgency = Urgency.today;
  late final TextEditingController _text = TextEditingController(
    text: widget.initialText ?? '',
  );
  String? _error;
  bool _busy = false;
  late bool _typeTouched = widget.initialKind != null;
  bool _moreOpen = false;
  final _amount = TextEditingController();
  String _unit = 'horas';
  DateTime? _date;
  String? _inReturn;
  final _more = TextEditingController();
  String? _photo;

  Future<void> _pickPhoto(ImageSource source) async {
    try {
      final x = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1280,
        imageQuality: 80,
      );
      if (x == null) return;
      final dir = await getApplicationDocumentsDirectory();
      final dest =
          '${dir.path}/pedido_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await File(x.path).copy(dest);
      if (mounted) setState(() => _photo = dest);
    } catch (e, st) {
      logError('composer_sheet', e, st);
      if (mounted) {
        setState(
          () => _error = 'No se pudo abrir la foto. Puedes publicar sin ella.',
        );
      }
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      helpText: '¿Para cuándo lo necesitas?',
    );
    if (d != null && mounted) {
      setState(() {
        _date = d;
        _urgency = Urgency.thisWeek;
      });
    }
  }

  String? _detailsText() {
    final parts = <String>[
      if (_amount.text.trim().isNotEmpty)
        'Duración: ${_amount.text.trim()} $_unit',
      if (_date != null)
        'Fecha: ${_date!.day.toString().padLeft(2, '0')}/${_date!.month.toString().padLeft(2, '0')}/${_date!.year}',
      if (_inReturn != null) 'A cambio: $_inReturn',
      if (_more.text.trim().isNotEmpty) _more.text.trim(),
    ];
    return parts.isEmpty ? null : parts.join('\n');
  }

  @override
  void dispose() {
    _text.dispose();
    _more.dispose();
    _amount.dispose();
    super.dispose();
  }

  Future<void> _publish() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final result = await ref.read(publishNeedProvider)(
      kind: _kind,
      text: _text.text,
      urgency: _urgency,
      details: _detailsText(),
      photoPath: _photo,
      categoryId: _kind == NeedKind.service ? widget.categoryId : null,
    );
    if (!mounted) return;
    switch (result) {
      case Ok(:final value):
        final router = GoRouter.of(context);
        final messenger = ScaffoldMessenger.of(context);
        Navigator.of(context).pop();
        await ref.read(syncControllerProvider.notifier).flushNow();
        messenger.showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 6),
            content: Text('Listo: tu pedido quedó guardado en tu teléfono.'),
          ),
        );
        router.go('/need/${value.id}');
      case Err(:final failure):
        setState(() {
          _busy = false;
          _error = failure.message;
        });
    }
  }

  /// Al elegir un tipo se precarga su primera frase (si no escribiste algo propio): así son 3 toques.
  void _pickKind(NeedKind k) => setState(() {
    final auto =
        _text.text.isEmpty ||
        NeedLabels.suggestions(_kind).contains(_text.text);
    _kind = k;
    _typeTouched = true;
    _error = null;
    if (auto) {
      _text.text = NeedLabels.suggestions(k).first;
    }
  });

  bool get _isSuggestion => NeedLabels.suggestions(_kind).contains(_text.text);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textOk = _text.text.trim().length >= 3;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        0,
        16,
        16 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('¿Qué necesitas?', style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 12),
                  _StepsHeader(done1: _typeTouched, done2: textOk),
                  const SizedBox(height: 14),
                  for (final k in NeedKind.values)
                    _TypeCard(
                      kind: k,
                      selected: _kind == k,
                      onTap: () => _pickKind(k),
                    ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final sug in NeedLabels.suggestions(_kind))
                        ChoiceChip(
                          label: Text(sug),
                          selected: _text.text == sug,
                          onSelected: (_) => setState(() {
                            _text.text = sug;
                            _typeTouched = true;
                          }),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _text,
                    minLines: 2,
                    maxLines: 3,
                    maxLength: 200,
                    textCapitalization: TextCapitalization.sentences,
                    style: _isSuggestion
                        ? TextStyle(color: theme.colorScheme.onSurfaceVariant)
                        : null,
                    decoration: InputDecoration(
                      helperText: _isSuggestion
                          ? 'Sugerencia: puedes editarla o escribir lo tuyo'
                          : null,
                      labelText: 'O cuéntalo con tus palabras',
                      errorText: _error,
                    ),
                    onChanged: (_) => setState(() => _error = null),
                  ),
                  Text(
                    '¿Para cuándo lo necesitas?',
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final u in const [
                        Urgency.now,
                        Urgency.today,
                        Urgency.tomorrow,
                      ])
                        ChoiceChip(
                          label: Text(
                            u == Urgency.now ? 'Ahora' : NeedLabels.urgency(u),
                          ),
                          selected: _date == null && _urgency == u,
                          onSelected: (_) => setState(() {
                            _urgency = u;
                            _date = null;
                          }),
                        ),
                      ChoiceChip(
                        avatar: const Icon(Icons.event, size: 18),
                        label: Text(
                          _date == null
                              ? 'Otra fecha'
                              : '${_date!.day}/${_date!.month}/${_date!.year}',
                        ),
                        selected: _date != null,
                        onSelected: (_) => _pickDate(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  MoreDetails(
                    open: _moreOpen,
                    onToggle: () => setState(() => _moreOpen = !_moreOpen),
                    kind: _kind,
                    amount: _amount,
                    unit: _unit,
                    onUnit: (v) => setState(() => _unit = v),
                    inReturn: _inReturn,
                    onInReturn: (v) => setState(() => _inReturn = v),
                    more: _more,
                    photo: _photo,
                    onCamera: () => _pickPhoto(ImageSource.camera),
                    onGallery: () => _pickPhoto(ImageSource.gallery),
                    onRemovePhoto: () => setState(() => _photo = null),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: (_busy || !textOk) ? null : _publish,
              child: Text(_busy ? 'Publicando…' : 'Publicar'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Indicador de 3 pasos dentro de la misma pantalla: no suma toques.
class _StepsHeader extends StatelessWidget {
  const _StepsHeader({required this.done1, required this.done2});

  final bool done1;
  final bool done2;

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    Widget step(int n, String label, bool done, bool active) {
      final bg = done
          ? s.primary
          : (active ? AppTheme.coral : Colors.transparent);
      final fg = done
          ? s.onPrimary
          : (active ? AppTheme.onCoral : s.onSurfaceVariant);
      return Semantics(
        label: 'Paso $n: $label${done ? ', listo' : ''}',
        child: ExcludeSemantics(
          child: Column(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: bg,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: done || active ? bg : s.outline,
                    width: 1.5,
                  ),
                ),
                child: done
                    ? Icon(Icons.check, size: 18, color: fg)
                    : Text(
                        '$n',
                        style: TextStyle(
                          color: fg,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget line(bool done) => Expanded(
      child: Container(
        height: 3,
        margin: const EdgeInsets.only(bottom: 20, left: 6, right: 6),
        decoration: BoxDecoration(
          color: done ? s.primary : s.outlineVariant,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );

    return Row(
      children: [
        step(1, 'Tipo', done1, !done1),
        line(done1),
        step(2, 'Describe', done2, done1 && !done2),
        line(done1 && done2),
        step(3, 'Publica', false, done1 && done2),
      ],
    );
  }
}

class _TypeCard extends StatelessWidget {
  const _TypeCard({
    required this.kind,
    required this.selected,
    required this.onTap,
  });

  final NeedKind kind;
  final bool selected;
  final VoidCallback onTap;

  static const _tint = {
    NeedKind.service: (AppTheme.sky, AppTheme.onSky),
    NeedKind.product: (AppTheme.mint, AppTheme.onMint),
    NeedKind.loan: (AppTheme.sun, AppTheme.onSun),
    NeedKind.help: (AppTheme.coralSoft, AppTheme.onSun),
  };

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    final t = _tint[kind]!;
    return Semantics(
      button: true,
      selected: selected,
      label: '${NeedLabels.kind(kind)}. ${NeedLabels.hint(kind)}',
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: selected ? s.primaryContainer : s.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: selected ? s.primary : s.outlineVariant,
                width: selected ? 2 : 1,
              ),
            ),
            child: ExcludeSemantics(
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: t.$1,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(NeedLabels.icon(kind), color: t.$2),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          NeedLabels.kind(kind),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          NeedLabels.hint(kind),
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    selected
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: selected ? s.primary : s.outline,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
