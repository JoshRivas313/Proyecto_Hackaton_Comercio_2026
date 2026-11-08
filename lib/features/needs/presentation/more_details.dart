import 'dart:io';

import 'package:flutter/material.dart';

/// «Agregar detalles» (opcional): tiempo, a cambio de qué, descripción y foto del problema.
/// Va plegado para no sumar toques al camino corto de publicar.
class MoreDetails extends StatelessWidget {
  const MoreDetails({
    super.key,
    required this.open,
    required this.onToggle,
    required this.howLong,
    required this.onHowLong,
    required this.inReturn,
    required this.onInReturn,
    required this.more,
    required this.photo,
    required this.onCamera,
    required this.onGallery,
    required this.onRemovePhoto,
  });

  final bool open;
  final VoidCallback onToggle;
  final String? howLong;
  final ValueChanged<String?> onHowLong;
  final String? inReturn;
  final ValueChanged<String?> onInReturn;
  final TextEditingController more;
  final String? photo;
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onRemovePhoto;

  Widget _chips(
    List<String> options,
    String? value,
    ValueChanged<String?> onChanged,
  ) => Wrap(
    spacing: 8,
    runSpacing: 4,
    children: [
      for (final o in options)
        ChoiceChip(
          label: Text(o),
          selected: value == o,
          onSelected: (sel) => onChanged(sel ? o : null),
        ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          onPressed: onToggle,
          icon: Icon(open ? Icons.expand_less : Icons.tune),
          label: Text(
            open ? 'Ocultar detalles' : 'Agregar detalles (opcional)',
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          alignment: Alignment.topCenter,
          child: open
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¿Por cuánto tiempo?',
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 6),
                      _chips(
                        const ['1 hora', 'Hoy', 'Varios días'],
                        howLong,
                        onHowLong,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '¿Ofreces algo a cambio?',
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 6),
                      _chips(
                        const ['Nada', 'Trueque', 'Propina'],
                        inReturn,
                        onInReturn,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: more,
                        minLines: 2,
                        maxLines: 4,
                        maxLength: 300,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          labelText: 'Cuéntalo con más detalle',
                          hintText: 'Qué pasó, qué ves, qué ya intentaste',
                        ),
                      ),
                      Text(
                        'Foto del problema',
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 6),
                      if (photo != null)
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.file(
                                File(photo!),
                                height: 140,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: IconButton.filledTonal(
                                tooltip: 'Quitar foto',
                                onPressed: onRemovePhoto,
                                icon: const Icon(Icons.close),
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
                      const SizedBox(height: 8),
                      Text(
                        'Solo la ven quienes te proponen. No compartimos tu ubicación exacta. Sin internet, se sube al volver.',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}
