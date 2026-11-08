/// Configuración que llega por `--dart-define` al compilar. NUNCA se escribe aquí una clave real.
///
///   flutter run --dart-define=SUPABASE_URL=(URL del proyecto) \
///               --dart-define=SUPABASE_ANON_KEY=(clave anon pública)
///
/// La clave `anon` es pública por diseño (la seguridad la dan las políticas RLS del servidor).
/// La clave `service_role` jamás va en la app.
class AppConfig {
  const AppConfig._();

  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  /// Hay datos para conectarse. Sin ellos la app funciona igual, con destino de demostración.
  static bool get hasSupabase =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  /// Lo pone `main()` solo si `Supabase.initialize` terminó bien. Si falla, la app sigue en demo.
  static bool supabaseReady = false;
}
