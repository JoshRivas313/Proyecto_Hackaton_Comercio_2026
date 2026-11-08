/// Categoría de servicio con identificador estable. Es la ÚNICA fuente: la usan las
/// categorías de Inicio, la solicitud publicada, las capacidades del prestador y los filtros
/// de Mapa, Radar y Lista. [label] es el rubro (filtro) y [person] la persona que lo hace.
class TradeCategory {
  const TradeCategory(this.id, this.label, this.person);

  final String id;
  final String label;
  final String person;
}

const tradeCategories = <TradeCategory>[
  TradeCategory('gasfiteria', 'Gasfitería', 'Gasfitero'),
  TradeCategory('electricidad', 'Electricidad', 'Electricista'),
  TradeCategory('carpinteria', 'Carpintería', 'Carpintero'),
  TradeCategory('cerrajeria', 'Cerrajería', 'Cerrajero'),
  TradeCategory('costura', 'Costura', 'Costura'),
  TradeCategory('clases', 'Clases', 'Clases'),
  TradeCategory('mascotas', 'Mascotas', 'Mascotas'),
];

/// Categoría por id, o `null`.
TradeCategory? tradeById(String? id) =>
    tradeCategories.where((c) => c.id == id).firstOrNull;

/// Categoría por rubro («Gasfitería») o por oficio («Gasfitero»), o `null`.
TradeCategory? tradeByName(String? name) => tradeCategories
    .where((c) => c.label == name || c.person == name)
    .firstOrNull;

/// Rubros mostrados como filtro en "Explorar cerca".
final serviceTrades = ['Todos', for (final c in tradeCategories) c.label];
const productTrades = ['Todos', 'Bodega', 'Minimarket', 'De un vecino'];
