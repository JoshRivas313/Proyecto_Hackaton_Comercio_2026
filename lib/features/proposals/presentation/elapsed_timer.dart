import 'dart:async';

import 'package:flutter/material.dart';

/// `mm:ss` de un tiempo transcurrido (nunca negativo).
String formatElapsed(Duration d) {
  final e = d.isNegative ? Duration.zero : d;
  final mm = e.inMinutes.toString().padLeft(2, '0');
  final ss = (e.inSeconds % 60).toString().padLeft(2, '0');
  return '$mm:$ss';
}

/// Temporizador del trato: cuenta HACIA ARRIBA desde que se validó el código.
///
/// Causa del error anterior: el `Timer` estaba declarado como `late final` y nunca se
/// leía, así que no llegaba a crearse y el texto solo cambiaba si otro widget reconstruía
/// la pantalla (se veía «00:01» fijo). Ahora el `Timer` se crea en `initState`.
/// El valor sale siempre de la hora real (`now() - since`), por eso sigue correcto al
/// pausar la app, cambiar de pantalla o reabrirla: al volver se recalcula de inmediato.
class ElapsedTimer extends StatefulWidget {
  const ElapsedTimer({super.key, required this.since, this.now = DateTime.now});

  final DateTime since;

  /// Reloj inyectable (para pruebas).
  final DateTime Function() now;

  @override
  State<ElapsedTimer> createState() => _ElapsedTimerState();
}

class _ElapsedTimerState extends State<ElapsedTimer>
    with WidgetsBindingObserver {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Al volver a la app se recalcula con la hora real.
    if (state == AppLifecycleState.resumed && mounted) setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = formatElapsed(widget.now().difference(widget.since));
    return Semantics(
      label: 'Tiempo en curso: $text',
      child: ExcludeSemantics(
        child: Text(text, style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}
