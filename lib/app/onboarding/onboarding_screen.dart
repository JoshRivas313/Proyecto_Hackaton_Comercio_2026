import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/motion.dart';
import '../widgets/neighborhood_hero.dart';

/// Bienvenida: ilustración de barrio, mensaje corto y una acción. Se puede saltar.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            children: [
              Expanded(
                child: FadeSlideIn(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [AppTheme.brand, Color(0xFF8B6BE8)],
                        ),
                      ),
                      child: const Align(
                        alignment: Alignment.bottomCenter,
                        child: NeighborhoodHero(height: 230),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FadeSlideIn(
                delayMs: 120,
                child: Column(
                  children: [
                    Text(
                      'Tu comunidad, más conectada',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Encuentra servicios, comparte recursos y recibe apoyo cuando lo necesites.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              FadeSlideIn(
                delayMs: 240,
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.coral,
                      foregroundColor: const Color(0xFF2A1670),
                      minimumSize: const Size(48, 60),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    onPressed: onDone,
                    child: const Text('Comenzar'),
                  ),
                ),
              ),
              TextButton(onPressed: onDone, child: const Text('Saltar')),
            ],
          ),
        ),
      ),
    );
  }
}
