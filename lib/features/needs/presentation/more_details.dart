import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../domain/need.dart';

/// Unidades de duración. «¿Cuánto tiempo lo necesitas?» es distinto de «¿Para cuándo?».
const durationUnits = ['minutos', 'horas', 'días', 'semanas'];

/// Bloque de detalles adaptado al tipo de necesidad (opcional).
/// - Préstamo: la duración va visible, porque es lo central.
/// - Servicio y Ayuda: duración opcional dentro del bloque plegable.
/// - Producto: sin duración.
class MoreDetails extends StatelessWidget {
  const MoreDetails({
    super.key,
    required this.kind,
    required this.open,
    required this.onToggle,
    required this.amount,
    required this.unit,
    required this.onUnit,
    required this.inReturn,
    required this.onInReturn,
    required this.more,
    required this.photo,
    required this.onCamera,
    required this.onGallery,
    required this.onRemovePhoto,
  });

  final NeedKind kind;
  final bool open;
  final VoidCallback onToggle;
  final TextEditingController amount;
  final String unit;
  final ValueChanged<String> onUnit;
  final String? inReturn;
  final ValueChanged<String?> onInReturn;
  final TextEditingController more;
  final String? photo;
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onRemovePhoto;

  bool get _durationFirst => kind == NeedKind.loan;
  bool get _hasDuration => kind != NeedKind.product;

  String get _moreLabel => switch (kind) {
    NeedKind.service => 'Cuéntalo con más detalle',
    NeedKind.product => 'Describe el producto que buscas',
    NeedKind.loan => 'Para qué lo necesitas',
    NeedKind.help => 'Cuéntalo con más detalle',
  };

  Widget _title(BuildContext context, String t, {String? hint}) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text.rich(
      TextSpan(
        text: t,
        style: Theme.of(context).textTheme.titleSmall,
        children: [
          if (hint != null)
            TextSpan(
              text: '  $hint',
              style: Theme.of(context).textTheme.bodySmall,
            ),
        ],
      ),
    ),
  );

  Widget _duration(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _title(
        context,
        '¿Cuánto tiempo lo necesitas?',
        hint: _durationFirst ? null : '(opcional)',
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 84,
            child: TextField(
              controller: amount,
              keyboardType: TextInputType.number,
              maxLength: 3,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: 'Ej. 2',
                counterText: '',
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Wrap(
              spacing: 6,
              runSpacing: 0,
              children: [
                for (final u in durationUnits)
                  ChoiceChip(
                    label: Text(u),
                    visualDensity: VisualDensity.compact,
                    selected: unit == u,
                    onSelected: (_) => onUnit(u),
                  ),
              ],
            ),
          ),
        ],
      ),
    ],
  );

  Widget _inReturn(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _title(
        context,
        '¿Ofreces algo a cambio?',
        hint: kind == NeedKind.help ? '(no es obligatorio)' : '(opcional)',
      ),
      Wrap(
        spacing: 8,
        children: [
          for (final o in const ['Nada', 'Trueque', 'Propina'])
            ChoiceChip(
              label: Text(o),
              selected: inReturn == o,
              onSelected: (sel) => onInReturn(sel ? o : null),
            ),
        ],
      ),
    ],
  );

  Widget _photo(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _title(context, 'Foto', hint: '(opcional)'),
      if (photo != null)
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.file(
                File(photo!),
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 6,
              right: 6,
              child: IconButton.filledTonal(
                tooltip: 'Quitar foto',
                onPressed: onRemovePhoto,
                icon: const Icon(Icons.delete_outline),
              ),
            ),
          ],
        )
      else
        Row(
          spacing: 8,
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onCamera,
                icon: const Icon(Icons.photo_camera_outlined),
                label: const Text('Cámara'),
              ),
            ),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onGallery,
                icon: const Icon(Icons.photo_library_outlined),
                label: const Text('Galería'),
              ),
            ),
          ],
        ),
      const SizedBox(height: 6),
      Text(
        'Solo la ven quienes te proponen. No compartimos tu ubicación exacta.',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_hasDuration && !_durationFirst) ...[
          _duration(context),
          const SizedBox(height: 12),
        ],
        if (kind != NeedKind.product) ...[
          _inReturn(context),
          const SizedBox(height: 12),
        ],
        TextField(
          controller: more,
          minLines: 2,
          maxLines: 4,
          maxLength: 300,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(labelText: _moreLabel),
        ),
        _photo(context),
      ],
    );

    Widget card(Widget child) => Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: child,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_durationFirst) ...[
          card(_duration(context)),
          const SizedBox(height: 8),
        ],
        TextButton.icon(
          onPressed: onToggle,
          icon: Icon(open ? Icons.expand_less : Icons.tune),
          label: Text(open ? 'Ocultar detalles' : 'Más detalles (opcional)'),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          alignment: Alignment.topCenter,
          child: open ? card(body) : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}
