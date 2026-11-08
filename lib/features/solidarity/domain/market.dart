import '../../../core/clock.dart';
import '../../../core/failure.dart';
import '../../../core/ids.dart';
import '../../../core/result.dart';

/// Producto que vendes: fijas un precio de lista y los vecinos compran o proponen uno menor.
class ProductSale {
  const ProductSale({
    required this.id,
    required this.text,
    required this.priceSoles,
    required this.createdAt,
    this.sold = false,
    this.soldPrice,
    this.soldTo,
    this.rejected = const {},
    this.photoPath,
  });

  final String id;

  /// Foto del producto en el teléfono (opcional).
  final String? photoPath;
  final String text;
  final int priceSoles;
  final DateTime createdAt;
  final bool sold;
  final int? soldPrice;
  final String? soldTo;

  /// Índices de las ofertas de ejemplo que ya rechazaste.
  final Set<int> rejected;

  ProductSale copyWith({
    bool? sold,
    int? soldPrice,
    String? soldTo,
    Set<int>? rejected,
  }) => ProductSale(
    id: id,
    text: text,
    priceSoles: priceSoles,
    createdAt: createdAt,
    sold: sold ?? this.sold,
    soldPrice: soldPrice ?? this.soldPrice,
    soldTo: soldTo ?? this.soldTo,
    rejected: rejected ?? this.rejected,
    photoPath: photoPath,
  );
}

/// Oferta de compra DE EJEMPLO (no hay compradores reales todavía).
class BuyerOffer {
  const BuyerOffer({
    required this.index,
    required this.who,
    required this.distanceMeters,
    required this.priceSoles,
    required this.atListPrice,
  });

  final int index;
  final String who;
  final double distanceMeters;
  final int priceSoles;
  final bool atListPrice;
}

/// Tres compradores de ejemplo (paridad con el PWA): uno paga el precio de lista, otros proponen menos.
List<BuyerOffer> buyerOffersFor(ProductSale sale) {
  int at(double f) => (sale.priceSoles * f).round().clamp(1, 1 << 30);
  return [
    BuyerOffer(
      index: 0,
      who: 'Lucía Prado',
      distanceMeters: 300,
      priceSoles: sale.priceSoles,
      atListPrice: true,
    ),
    BuyerOffer(
      index: 1,
      who: 'Mario Soto',
      distanceMeters: 550,
      priceSoles: at(0.8),
      atListPrice: false,
    ),
    BuyerOffer(
      index: 2,
      who: 'Gloria Vera',
      distanceMeters: 800,
      priceSoles: at(0.6),
      atListPrice: false,
    ),
  ];
}

/// Oferta propia al muro del barrio (sin dinero): préstamo, trueque, donación…
class WallOffer {
  const WallOffer({
    required this.id,
    required this.mode,
    required this.text,
    required this.createdAt,
  });

  final String id;
  final String mode;
  final String text;
  final DateTime createdAt;
}

abstract interface class MarketRepository {
  Future<Result<void>> saveSale(ProductSale sale);
  Future<ProductSale?> saleById(String id);
  Stream<List<ProductSale>> watchSales();
  Future<Result<void>> saveWallOffer(WallOffer offer);
  Stream<List<WallOffer>> watchWallOffers();
}

class PublishProductSale {
  PublishProductSale({
    required this.repo,
    required this.clock,
    required this.ids,
  });

  final MarketRepository repo;
  final Clock clock;
  final IdGenerator ids;

  Future<Result<ProductSale>> call(
    String text,
    String priceText, {
    String? photoPath,
  }) async {
    final clean = text.trim();
    final digits = RegExp(r'\d+').firstMatch(priceText)?.group(0);
    final price = digits == null ? 0 : int.parse(digits);
    if (clean.length < 3) {
      return const Err(
        ValidationFailure('Describe tu producto (al menos 3 letras).'),
      );
    }
    if (price <= 0) {
      return const Err(ValidationFailure('Escribe el precio de lista.'));
    }
    final sale = ProductSale(
      id: ids.newUuid(),
      text: clean,
      priceSoles: price,
      createdAt: clock.now(),
      photoPath: photoPath,
    );
    final r = await repo.saveSale(sale);
    if (r case Err(:final failure)) {
      return Err(failure);
    }
    return Ok(sale);
  }
}

/// Acepta o rechaza una oferta de ejemplo. Aceptar cierra la venta; no hay contraofertas.
class DecideBuyerOffer {
  DecideBuyerOffer(this.repo);

  final MarketRepository repo;

  Future<Result<void>> accept(String saleId, int index) async {
    final sale = await repo.saleById(saleId);
    if (sale == null || sale.sold) {
      return const Err(ValidationFailure('Este producto ya se vendió.'));
    }
    final offer = buyerOffersFor(sale)
        .where((o) => o.index == index)
        .firstOrNull;
    if (offer == null || sale.rejected.contains(index)) {
      return const Err(ValidationFailure('Esa oferta ya no está disponible.'));
    }
    return repo.saveSale(
      sale.copyWith(sold: true, soldPrice: offer.priceSoles, soldTo: offer.who),
    );
  }

  Future<Result<void>> reject(String saleId, int index) async {
    final sale = await repo.saleById(saleId);
    if (sale == null || sale.sold) {
      return const Err(ValidationFailure('Este producto ya se vendió.'));
    }
    return repo.saveSale(sale.copyWith(rejected: {...sale.rejected, index}));
  }
}

const wallOfferModes = [
  'Préstamo',
  'Trueque',
  'Alquiler',
  'Donación',
  'Favor',
  'Intercambio de habilidades',
  'Movilidad solidaria',
];

class PublishWallOffer {
  PublishWallOffer({
    required this.repo,
    required this.clock,
    required this.ids,
  });

  final MarketRepository repo;
  final Clock clock;
  final IdGenerator ids;

  Future<Result<WallOffer>> call(String? mode, String text) async {
    if (mode == null || !wallOfferModes.contains(mode)) {
      return const Err(ValidationFailure('Elige una modalidad.'));
    }
    if (text.trim().length < 3) {
      return const Err(
        ValidationFailure('Cuenta qué ofreces (al menos 3 letras).'),
      );
    }
    final offer = WallOffer(
      id: ids.newUuid(),
      mode: mode,
      text: text.trim(),
      createdAt: clock.now(),
    );
    final r = await repo.saveWallOffer(offer);
    if (r case Err(:final failure)) {
      return Err(failure);
    }
    return Ok(offer);
  }
}
