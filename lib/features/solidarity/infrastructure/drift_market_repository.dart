import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import '../../../core/failure.dart';
import '../../../core/result.dart';
import '../domain/market.dart';
import '../../../core/log.dart';

class DriftMarketRepository implements MarketRepository {
  DriftMarketRepository(this._db);

  final AppDatabase _db;

  @override
  Future<Result<void>> saveSale(ProductSale s) async {
    try {
      await _db
          .into(_db.productSales)
          .insertOnConflictUpdate(
            ProductSalesCompanion.insert(
              id: s.id,
              body: s.text,
              priceSoles: s.priceSoles,
              sold: Value(s.sold),
              soldPrice: Value(s.soldPrice),
              soldTo: Value(s.soldTo),
              rejected: Value(s.rejected.join(',')),
              createdAt: s.createdAt,
              photoPath: Value(s.photoPath),
            ),
          );
      return const Ok(null);
    } catch (e, st) {
      logError('drift_market_repository', e, st);
      return const Err(StorageFailure('No se pudo guardar tu producto.'));
    }
  }

  ProductSale _sale(ProductSaleRow r) => ProductSale(
    id: r.id,
    text: r.body,
    priceSoles: r.priceSoles,
    createdAt: r.createdAt,
    photoPath: r.photoPath,
    sold: r.sold,
    soldPrice: r.soldPrice,
    soldTo: r.soldTo,
    rejected: r.rejected.isEmpty
        ? <int>{}
        : r.rejected.split(',').map(int.parse).toSet(),
  );

  @override
  Future<ProductSale?> saleById(String id) async {
    final r = await (_db.select(
      _db.productSales,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return r == null ? null : _sale(r);
  }

  @override
  Stream<List<ProductSale>> watchSales() =>
      (_db.select(_db.productSales)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch()
          .map((rows) => rows.map(_sale).toList());

  @override
  Future<Result<void>> saveWallOffer(WallOffer o) async {
    try {
      await _db
          .into(_db.wallOffers)
          .insertOnConflictUpdate(
            WallOffersCompanion.insert(
              id: o.id,
              mode: o.mode,
              body: o.text,
              createdAt: o.createdAt,
            ),
          );
      return const Ok(null);
    } catch (e, st) {
      logError('drift_market_repository', e, st);
      return const Err(StorageFailure('No se pudo guardar tu oferta.'));
    }
  }

  @override
  Stream<List<WallOffer>> watchWallOffers() =>
      (_db.select(
        _db.wallOffers,
      )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch().map(
        (rows) => [
          for (final r in rows)
            WallOffer(
              id: r.id,
              mode: r.mode,
              text: r.body,
              createdAt: r.createdAt,
            ),
        ],
      );
}
