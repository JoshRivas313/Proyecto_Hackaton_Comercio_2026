import 'package:flutter/material.dart';

/// Ilustración original de barrio: casas, sol y vecinos de varias edades.
/// Dibujada con formas (sin imágenes de terceros, sin emojis) y muy liviana.
class NeighborhoodHero extends StatelessWidget {
  const NeighborhoodHero({super.key, this.height = 150});

  final double height;

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Ilustración: vecinos de distintas edades frente a las casas del barrio',
    child: ExcludeSemantics(
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: CustomPaint(painter: _NeighborhoodPainter()),
      ),
    ),
  );
}

class _NeighborhoodPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final p = Paint()..style = PaintingStyle.fill;

    // Sol y nubes
    p.color = const Color(0xFFFFD166);
    canvas.drawCircle(Offset(w * 0.84, h * 0.22), h * 0.16, p);
    p.color = Colors.white.withValues(alpha: 0.35);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.06, h * 0.12, w * 0.2, h * 0.09),
        const Radius.circular(20),
      ),
      p,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.14, h * 0.07, w * 0.14, h * 0.09),
        const Radius.circular(20),
      ),
      p,
    );

    // Colinas
    p.color = const Color(0xFF3B2790);
    final hill = Path()
      ..moveTo(0, h * 0.78)
      ..quadraticBezierTo(w * 0.25, h * 0.55, w * 0.55, h * 0.74)
      ..quadraticBezierTo(w * 0.8, h * 0.86, w, h * 0.7)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(hill, p);

    // Casas
    void house(
      double x,
      double base,
      double hw,
      double hh,
      Color wall,
      Color roof,
    ) {
      p.color = wall;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, base - hh, hw, hh),
          const Radius.circular(6),
        ),
        p,
      );
      p.color = roof;
      final r = Path()
        ..moveTo(x - hw * 0.08, base - hh)
        ..lineTo(x + hw / 2, base - hh - hw * 0.42)
        ..lineTo(x + hw * 1.08, base - hh)
        ..close();
      canvas.drawPath(r, p);
      p.color = Colors.white.withValues(alpha: 0.9);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x + hw * 0.18, base - hh * 0.72, hw * 0.24, hw * 0.24),
          const Radius.circular(3),
        ),
        p,
      );
      p.color = const Color(0xFF5B3FC4).withValues(alpha: 0.85);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x + hw * 0.58, base - hh * 0.55, hw * 0.24, hh * 0.55),
          const Radius.circular(4),
        ),
        p,
      );
    }

    final base = h * 0.84;
    house(
      w * 0.05,
      base,
      w * 0.17,
      h * 0.34,
      const Color(0xFFFFE1D6),
      const Color(0xFFFF8A65),
    );
    house(
      w * 0.25,
      base,
      w * 0.2,
      h * 0.46,
      const Color(0xFFBDEFD3),
      const Color(0xFF0A6B66),
    );
    house(
      w * 0.52,
      base,
      w * 0.15,
      h * 0.3,
      const Color(0xFFCDE7FF),
      const Color(0xFF5B3FC4),
    );
    house(
      w * 0.71,
      base,
      w * 0.19,
      h * 0.4,
      const Color(0xFFFFD166),
      const Color(0xFFC42B1A),
    );

    // Vecinos: adulto mayor con bastón, adulta y niño
    void person(
      double cx,
      double feet,
      double ph,
      Color body,
      Color skin, {
      bool cane = false,
    }) {
      p.color = body;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(cx, feet - ph * 0.33),
            width: ph * 0.34,
            height: ph * 0.56,
          ),
          Radius.circular(ph * 0.14),
        ),
        p,
      );
      p.color = skin;
      canvas.drawCircle(Offset(cx, feet - ph * 0.72), ph * 0.13, p);
      if (cane) {
        p.color = const Color(0xFF4A1F00);
        canvas.drawRect(
          Rect.fromLTWH(cx + ph * 0.2, feet - ph * 0.5, 3, ph * 0.5),
          p,
        );
      }
    }

    final feet = h * 0.97;
    person(
      w * 0.36,
      feet,
      h * 0.5,
      const Color(0xFFFF8A65),
      const Color(0xFFE0A87C),
      cane: true,
    );
    person(
      w * 0.5,
      feet,
      h * 0.56,
      const Color(0xFF5B3FC4),
      const Color(0xFFB97A56),
    );
    person(
      w * 0.62,
      feet,
      h * 0.36,
      const Color(0xFFFFD166),
      const Color(0xFFF2C29B),
    );

    // Corazón entre dos vecinos: ayuda mutua
    p.color = const Color(0xFFFF8A65);
    final c = Offset(w * 0.56, h * 0.5);
    canvas.drawCircle(c.translate(-5, 0), 6, p);
    canvas.drawCircle(c.translate(5, 0), 6, p);
    canvas.drawPath(
      Path()
        ..moveTo(c.dx - 11, c.dy + 2)
        ..lineTo(c.dx, c.dy + 15)
        ..lineTo(c.dx + 11, c.dy + 2)
        ..close(),
      p,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
