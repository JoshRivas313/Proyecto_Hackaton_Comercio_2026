import 'package:flutter/material.dart';

import '../domain/need.dart';
import 'composer_sheet.dart';

class _Category {
  const _Category(
    this.label,
    this.icon,
    this.bg,
    this.fg,
    this.kind,
    this.text,
  );
  final String label;
  final IconData icon;
  final Color bg;
  final Color fg;
  final NeedKind kind;
  final String text;
}

// Fondos pastel con texto/ícono oscuro (contraste ≥ 4,5:1).
const _categories = [
  _Category(
    'Gasfitero',
    Icons.plumbing,
    Color(0xFFD9ECFF),
    Color(0xFF0B3A6B),
    NeedKind.service,
    'Necesito un gasfitero para arreglar una fuga',
  ),
  _Category(
    'Electricista',
    Icons.bolt,
    Color(0xFFFFE9A8),
    Color(0xFF4A3300),
    NeedKind.service,
    'Necesito un electricista, se fue la luz en la cocina',
  ),
  _Category(
    'Cerrajero',
    Icons.key,
    Color(0xFFE9E3FF),
    Color(0xFF3B2790),
    NeedKind.service,
    'Necesito un cerrajero, perdí mis llaves',
  ),
  _Category(
    'Carpintero',
    Icons.carpenter,
    Color(0xFFFFD9BF),
    Color(0xFF4A2200),
    NeedKind.service,
    'Necesito un carpintero para arreglar un mueble',
  ),
  _Category(
    'Costura',
    Icons.checkroom,
    Color(0xFFFFDDEB),
    Color(0xFF5A0F33),
    NeedKind.service,
    'Necesito arreglar un pantalón',
  ),
  _Category(
    'Clases',
    Icons.menu_book,
    Color(0xFFD5EEEB),
    Color(0xFF063F3C),
    NeedKind.service,
    'Necesito clases de matemática para mi hijo',
  ),
  _Category(
    'Mascotas',
    Icons.pets,
    Color(0xFFE3F3D3),
    Color(0xFF244A0B),
    NeedKind.service,
    'Necesito que alguien pasee a mi perro',
  ),
  _Category(
    'Agua y víveres',
    Icons.water_drop_outlined,
    Color(0xFFD9ECFF),
    Color(0xFF0B3A6B),
    NeedKind.product,
    'Necesito 2 bidones de agua',
  ),
];

/// Atajos por oficio: 1 toque abre el formulario ya lleno; con "Publicar" son 2 toques.
class CategoryTiles extends StatelessWidget {
  const CategoryTiles({super.key});

  @override
  Widget build(BuildContext context) {
    // Con texto grande del sistema: menos columnas y más alto, sin recortes.
    final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
    return GridView.count(
      crossAxisCount: scale > 1.3 ? 3 : 4,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 0.82 / scale.clamp(1.0, 2.0),
      children: [
        for (final c in _categories)
          Semantics(
            button: true,
            label: 'Pedir: ${c.label}',
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => showComposer(context, kind: c.kind, text: c.text),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: c.bg,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(c.icon, color: c.fg, size: 30),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    c.label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
