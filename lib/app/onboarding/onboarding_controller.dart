import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

/// Recuerda si ya se vio la bienvenida. Un archivo marcador en el teléfono: sin dependencias nuevas
/// ni cambios en la base de datos. Si no se puede leer, se muestra la bienvenida (nunca bloquea la app).
class OnboardingController extends AsyncNotifier<bool> {
  Future<File> _marker() async {
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}/onboarding_seen');
  }

  @override
  Future<bool> build() async {
    try {
      return await (await _marker()).exists();
    } catch (_) {
      return true; // ante la duda no estorbamos: la app abre directo
    }
  }

  Future<void> complete() async {
    state = const AsyncData(true);
    try {
      await (await _marker()).writeAsString('1');
    } catch (_) {
      // Si no se pudo guardar, la bienvenida volverá a aparecer: no es grave.
    }
  }
}

final onboardingControllerProvider =
    AsyncNotifierProvider<OnboardingController, bool>(OnboardingController.new);
