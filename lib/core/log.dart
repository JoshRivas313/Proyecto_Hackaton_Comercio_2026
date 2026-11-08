import 'dart:developer' as developer;

/// Registra un error inesperado SIN mostrarlo al usuario (que ve un mensaje claro de `Failure`).
/// Antes los `catch (_)` se tragaban la causa; ahora queda en el registro de desarrollo
/// (visible con `flutter logs` o DevTools) sin imprimir datos personales.
void logError(String where, Object error, StackTrace stack) {
  developer.log(
    'Error en $where',
    name: 'red_barrio',
    error: error,
    stackTrace: stack,
    level: 1000,
  );
}
