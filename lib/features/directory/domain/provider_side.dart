import '../../../core/clock.dart';
import '../../../core/failure.dart';
import '../../../core/ids.dart';
import '../../../core/result.dart';

/// Oficios que una persona puede ofrecer (paridad con `SVCS` del PWA).
const offerTrades = [
  'Gasfitería',
  'Electricidad',
  'Costura',
  'Clases particulares',
  'Cuidado de niños',
  'Otro',
];
const offerAvailabilities = ['Hoy', 'Esta semana', 'Fines de semana'];

/// Lo que haces y cuándo puedes. SIN precio: el precio se propone al ver cada pedido.
class ServiceOffer {
  const ServiceOffer({
    required this.id,
    required this.trade,
    required this.availability,
    required this.createdAt,
  });

  final String id;
  final String trade;
  final String availability;
  final DateTime createdAt;
}

/// Pedido de un vecino que coincide con lo que haces. De ejemplo hasta que haya cuentas.
class JobRequest {
  const JobRequest({
    required this.id,
    required this.trade,
    required this.who,
    required this.text,
    required this.distanceMeters,
    required this.when,
    required this.referencePrice,
    this.isExample = true,
  });

  final String id;
  final String trade;
  final String who;
  final String text;

  /// Distancia APROXIMADA: la dirección exacta solo se ve si te aceptan (regla inviolable 3).
  final double distanceMeters;
  final String when;
  final String referencePrice;
  final bool isExample;
}

class JobProposal {
  const JobProposal({
    required this.jobId,
    required this.priceSoles,
    required this.sentAt,
  });

  final String jobId;
  final int priceSoles;
  final DateTime sentAt;
}

abstract interface class ProviderRepository {
  Future<Result<void>> saveOffer(ServiceOffer offer);
  Stream<List<ServiceOffer>> watchOffers();
  Future<Result<void>> saveProposal(JobProposal proposal);
  Stream<List<JobProposal>> watchProposals();
}

/// Pedidos que llegan a quien ofrece un oficio.
/// Local: ejemplos. Remoto (mobile-mejoras): pedidos reales cercanos (PostGIS + Realtime).
abstract interface class JobBoard {
  Future<List<JobRequest>> requestsFor(String trade);
}

class PublishServiceOffer {
  PublishServiceOffer({
    required this.repo,
    required this.clock,
    required this.ids,
  });

  final ProviderRepository repo;
  final Clock clock;
  final IdGenerator ids;

  Future<Result<ServiceOffer>> call({
    required String trade,
    required String availability,
  }) async {
    if (!offerTrades.contains(trade)) {
      return const Err(ValidationFailure('Elige qué haces.'));
    }
    final offer = ServiceOffer(
      id: ids.newUuid(),
      trade: trade,
      availability: availability,
      createdAt: clock.now(),
    );
    final r = await repo.saveOffer(offer);
    if (r case Err(:final failure)) {
      return Err(failure);
    }
    return Ok(offer);
  }
}

/// El proveedor propone SU precio. No se puede enviar sin precio.
class SendJobProposal {
  SendJobProposal({required this.repo, required this.clock});

  final ProviderRepository repo;
  final Clock clock;

  Future<Result<JobProposal>> call(String jobId, String priceText) async {
    final digits = RegExp(r'\d+').firstMatch(priceText)?.group(0);
    final price = digits == null ? 0 : int.parse(digits);
    if (price <= 0) {
      return const Err(
        ValidationFailure('Escribe tu precio para enviar la propuesta.'),
      );
    }
    final p = JobProposal(jobId: jobId, priceSoles: price, sentAt: clock.now());
    final r = await repo.saveProposal(p);
    if (r case Err(:final failure)) {
      return Err(failure);
    }
    return Ok(p);
  }
}
