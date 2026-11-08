import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/sync/presentation/sync_controller.dart';
import 'onboarding/onboarding_controller.dart';
import 'onboarding/onboarding_screen.dart';
import 'router.dart';
import 'theme/app_theme.dart';

class RedBarrioApp extends ConsumerWidget {
  const RedBarrioApp({super.key});

  static const _locales = [Locale('es'), Locale('en')];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Vacía la cola al abrir y al volver la red.
    ref.watch(syncControllerProvider);
    final seen = ref.watch(onboardingControllerProvider);

    // La primera vez se muestra la bienvenida; después, la app normal.
    if (seen.value == false) {
      return MaterialApp(
        title: 'Red del barrio',
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        locale: const Locale('es'),
        supportedLocales: _locales,
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: OnboardingScreen(
          onDone: () =>
              ref.read(onboardingControllerProvider.notifier).complete(),
        ),
      );
    }
    return MaterialApp.router(
      title: 'Red del barrio',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: appRouter,
      locale: const Locale('es'),
      supportedLocales: _locales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
    );
  }
}
