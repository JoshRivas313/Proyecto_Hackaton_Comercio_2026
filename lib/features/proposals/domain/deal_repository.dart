import '../../../core/result.dart';
import 'deal.dart';

abstract interface class DealRepository {
  Future<Result<void>> save(Deal deal);

  /// Guarda el trato SOLO si el pedido aún no tiene ninguno. `Ok(true)` si lo creó.
  Future<Result<bool>> saveIfNoneForNeed(Deal deal);

  Future<Deal?> byId(String id);

  Future<Deal?> byNeed(String needId);

  Stream<List<Deal>> watchAll();
}
