# Red del barrio — guía para Claude

App móvil comunitaria (Flutter) para el VIII Hackathon UTP × El Comercio 2026: vecinos piden y ofrecen
ayuda, con foco en adultos mayores. Migración de una PWA anterior (`index.html`, `sw.js`) a Flutter.

## Reglas inviolables (no se negocian)
1. Máximo **3 toques** en las acciones principales (pedir, ofrecer, emergencia).
2. **Funciona sin internet** (offline primero): se guarda en el teléfono y se envía después.
3. La **ubicación exacta nunca es pública**: solo una zona redondeada (~1 km).
4. **Sin puntos ni rankings públicos**: no mostrar promedios de estrellas ni ordenar por puntaje.
   Solo conteos confirmados (Visto Bueno), con la regla anti-inflado (1 recomendación por persona y prestador).
5. En emergencias, **primero la institución oficial** (llamar); la app no promete avisar a nadie.
6. Español **claro y sencillo**, pensado para todas las edades.

Además: nunca presentar datos simulados como reales; no inventar calificaciones ni verificaciones.

## Comandos
```bash
flutter pub get
flutter analyze            # debe quedar sin avisos
flutter test               # todas deben pasar
flutter run --dart-define=SUPABASE_URL=(URL) --dart-define=SUPABASE_ANON_KEY=(clave pública)
flutter build apk --debug  # sin --dart-define la app corre en modo demostración
```
Sin las dos claves la app funciona igual con un destino de demostración.

## Arquitectura (hexagonal pragmática, por funcionalidad)
`lib/features/<x>/{domain,infrastructure,presentation}`; `lib/core` (Result/Failure, reloj, ids, Drift); `lib/app`.
- **domain**: Dart puro. No importa Flutter, Drift, Supabase, etc. Lo vigila `test/architecture/dependency_rules_test.dart`.
- **infrastructure**: adaptadores (Drift, Supabase, geolocalización, conectividad).
- **presentation**: pantallas Riverpod; no importan adaptadores.
- La inyección de dependencias vive **solo** en `lib/app/di/providers.dart`.
- Errores: `Result<T>` (`Ok`/`Err`) con `Failure`; nada de excepciones hacia la UI. Registrar con `logError` (`lib/core/log.dart`), no con `catch (_)`.
- Offline: cola de pendientes (Outbox) con UUID de cliente, idempotente. `SyncController` reintenta con esperas.
- Base local: Drift (SQLite), `schemaVersion` 12; cada cambio de esquema lleva su migración `from < N`.

## Supabase
- El servidor real existe (proyecto propio del equipo). El SQL está en la rama **`main`**, carpeta `supabase/`:
  4 migraciones y pruebas, ya aplicadas y probadas en el proyecto real. Las reglas críticas viven en el servidor (RLS y funciones `security definer`).
- Hoy la app solo sincroniza **pedidos** y **emergencias no sensibles** (`SupabaseSyncGateway`). Propuestas, tratos,
  contraofertas, calificaciones y chat siguen siendo locales: es el siguiente trabajo.
- Los casos de violencia **nunca** salen del teléfono.
- **Jamás** poner en el repositorio ni en el chat claves `service_role`/`secret` ni tokens. La clave pública va por `--dart-define`.

## Forma de trabajo
- Commits pequeños y descriptivos, **en español**.
- No hacer `push`, `merge`, `rebase` forzado ni borrar ramas sin que el usuario lo pida.
- No crear ramas nuevas sin pedirlo. `main`: documentos y SQL. `mobile-feedback`: la app.
- Si cambias la interfaz, verifica en el emulador; si cambias reglas del servidor, pruébalas con los SQL de `supabase/tests`.
- Documentos de contexto: `docs/ARQUITECTURA.md`, `docs/DECISIONES.md`, `docs/PLAN-48H.md`, `INFORME-ESTADO-ACTUAL.md`.

## Deuda técnica conocida
Pantallas con `setState` (falta pasarlas a controladores), `providers.dart` muy grande, textos sin internacionalizar,
pocas pruebas de widgets, sin prueba por versión de migración, lado del prestador sin interfaz, prueba en teléfono real pendiente.
