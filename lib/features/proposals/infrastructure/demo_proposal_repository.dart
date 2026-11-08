import '../../directory/infrastructure/demo_seed.dart';
import '../../directory/domain/trades.dart';
import '../../needs/domain/need.dart';
import '../domain/proposal.dart';
import '../domain/proposal_repository.dart';

/// Propuestas de DEMOSTRACIÓN (todas con `isExample: true`).
/// En mobile-mejoras se reemplaza por propuestas reales de vecinos (Supabase + Realtime).
///
/// Para pedidos de SERVICIO, las propuestas salen del oficio que aparece en el texto
/// (un pedido de electricista no recibe gasfiteros). Si no se reconoce ningún oficio,
/// no se inventan propuestas: la lista queda vacía y la pantalla lo explica.
class DemoProposalRepository implements ProposalRepository {
  const DemoProposalRepository();

  @override
  Future<List<Proposal>> forNeed(Need need) async {
    if (need.kind != NeedKind.service) {
      return demoProposals[need.kind] ?? const [];
    }
    final trade = tradeById(need.categoryId)?.label ?? detectTrade(need.text);
    return trade == null ? const [] : (demoServiceProposals[trade] ?? const []);
  }

  /// Oficio reconocido en el texto, o `null`. Ignora mayúsculas y tildes.
  static String? detectTrade(String text) {
    final t = _normalize(text);
    for (final entry in demoTradeKeywords.entries) {
      if (entry.value.any(t.contains)) return entry.key;
    }
    return null;
  }

  static String _normalize(String s) {
    const from = 'áéíóúüñ';
    const to = 'aeiouun';
    var out = s.toLowerCase();
    for (var i = 0; i < from.length; i++) {
      out = out.replaceAll(from[i], to[i]);
    }
    return out;
  }
}
