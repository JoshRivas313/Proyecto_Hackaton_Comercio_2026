import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../domain/need.dart';

/// Unidades de duración (un solo selector desplegable).
const durationUnits = ['minutos', 'horas', 'días', 'semanas'];

/// «Agregar información adicional (opcional)»: cerrado al inicio. Nada de aquí es obligatorio.
/// Los campos cambian según el tipo: Producto no pide duración ni «a cambio».
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

  String get _durationLabel => kind == NeedKind.loan
      ? 'Duración del préstamo (opcional)'
      : 'Duración (opcional)';

  String get _moreLabel => switch (kind) {
    NeedKind.product => 'Describe el producto que buscas',
    NeedKind.loan => 'Para qué lo necesitas',
    _ => 'Cuéntalo con más detalle',
  };

  Widget _label(BuildContext context, String t) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(t, style: Theme.of(context).textTheme.titleSmall),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasDuration = kind != NeedKind.product;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Agregar información adicional (opcional)',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                Icon(
                  open ? Icons.expand_less : Icons.expand_more,
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          alignment: Alignment.topCenter,
          child: !open
              ? const SizedBox(width: double.infinity)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasDuration) ...[
                      _label(context, _durationLabel),
                      Row(
                        children: [
                          SizedBox(
                            width: 96,
                            child: TextField(
                              controller: amount,
                              keyboardType: TextInputType.number,
                              maxLength: 3,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: const InputDecoration(
                                hintText: 'Cantidad',
                                counterText: '',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: unit,
                              items: [
                                for (final u in durationUnits)
                                  DropdownMenuItem(value: u, child: Text(u)),
                              ],
                              onChanged: (v) {
                                if (v != null) onUnit(v);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (kind != NeedKind.product) ...[
                      _label(
                        context,
                        kind == NeedKind.help
                            ? '¿Ofreces algo a cambio? (no es obligatorio)'
                            : '¿Ofreces algo a cambio? (opcional)',
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
                      const SizedBox(height: 16),
                    ],
                    TextField(
                      controller: more,
                      minLines: 2,
                      maxLines: 4,
                      maxLength: 300,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: '$_moreLabel (opcional)',
                      ),
                    ),
                    _label(context, 'Foto (opcional)'),
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
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
        ),
      ],
    );
  }
}
