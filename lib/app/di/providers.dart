import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/clock.dart';
import '../../core/db/app_database.dart';
import '../../core/ids.dart';
import '../../core/infrastructure/uuid_id_generator.dart';
import '../../features/deals_chat/domain/chat.dart';
import '../../features/proposals/domain/negotiation.dart';
import '../../features/proposals/domain/price_change.dart';
import '../../features/proposals/infrastructure/drift_price_change_repository.dart';
import '../../features/reputation/domain/rate_participant.dart';
import '../../features/solidarity/domain/post_response.dart';
import '../../features/solidarity/infrastructure/drift_post_response_repository.dart';
import '../../features/proposals/domain/usecases/negotiate.dart';
import '../../features/proposals/infrastructure/drift_negotiation_repository.dart';
import '../../features/deals_chat/domain/chat_format.dart';
import '../../features/deals_chat/infrastructure/drift_deal_chat.dart';
import '../../features/solidarity/domain/market.dart';
import '../../features/solidarity/infrastructure/drift_market_repository.dart';
import '../../features/directory/domain/directory_repository.dart';
import '../../features/directory/domain/provider_side.dart';
import '../../features/directory/infrastructure/demo_job_board.dart';
import '../../features/directory/infrastructure/drift_provider_repository.dart';
import '../../features/emergency/domain/emergency.dart';
import '../../features/emergency/domain/usecases/publish_sos.dart';
import '../../features/emergency/infrastructure/drift_emergency_repository.dart';
import '../../features/directory/infrastructure/demo_directory_repository.dart';
import '../../features/explore/domain/explore_nearby.dart';
import '../../features/location/domain/location_provider.dart';
import '../../features/location/infrastructure/geolocator_location_provider.dart';
import '../../features/needs/domain/need.dart';
import '../../features/needs/domain/need_repository.dart';
import '../../features/needs/domain/usecases/publish_need.dart';
import '../../features/needs/infrastructure/drift_need_repository.dart';
import '../../features/proposals/domain/deal.dart';
import '../../features/proposals/domain/deal_repository.dart';
import '../../features/proposals/domain/proposal_repository.dart';
import '../../features/proposals/domain/usecases/deal_usecases.dart';
import '../../features/proposals/domain/usecases/list_proposals.dart';
import '../../features/proposals/infrastructure/demo_proposal_repository.dart';
import '../../features/proposals/infrastructure/drift_deal_repository.dart';
import '../../features/reputation/domain/interaction.dart';
import '../../features/reputation/domain/reputation_repository.dart';
import '../../features/reputation/infrastructure/drift_reputation_repository.dart';
import '../../features/sync/domain/connectivity_monitor.dart';
import '../../features/sync/domain/outbox_queue.dart';
import '../../features/sync/domain/sync_gateway.dart';
import '../../features/sync/domain/usecases/flush_outbox.dart';
import '../../features/sync/infrastructure/connectivity_plus_monitor.dart';
import '../../features/sync/infrastructure/demo_sync_gateway.dart';
import '../../features/sync/infrastructure/drift_outbox.dart';
import '../../features/sync/infrastructure/supabase_remote_store.dart';
import '../../features/sync/infrastructure/supabase_sync_gateway.dart';
import '../config.dart';

/// ÚNICO lugar que decide qué adaptador implementa cada puerto.
/// mobile-ux: adaptadores locales (Drift) y datos de demostración.
/// mobile-mejoras: aquí se cambian por los de Supabase, sin tocar dominio ni pantallas.

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase.open();
  ref.onDispose(db.close);
  return db;
});

final clockProvider = Provider<Clock>((_) => const SystemClock());
final idGeneratorProvider = Provider<IdGenerator>((_) => UuidIdGenerator());

// --- Puertos ---
final needRepositoryProvider = Provider<NeedRepository>(
  (ref) => DriftNeedRepository(ref.watch(appDatabaseProvider)),
);
final outboxProvider = Provider<OutboxQueue>(
  (ref) => DriftOutbox(ref.watch(appDatabaseProvider)),
);

/// Con claves de Supabase (`--dart-define`) y la conexión iniciada, el destino es el servidor
/// real. Sin ellas, la app sigue funcionando igual con el destino de demostración.
final syncGatewayProvider = Provider<SyncGateway>(
  (_) => AppConfig.supabaseReady
      ? SupabaseSyncGateway(SupabaseRemoteStore(Supabase.instance.client))
      : const DemoSyncGateway(),
);
final connectivityProvider = Provider<ConnectivityMonitor>(
  (_) => ConnectivityPlusMonitor(),
);
final locationProvider = Provider<LocationProvider>(
  (_) => const GeolocatorLocationProvider(),
);
final directoryRepositoryProvider = Provider<DirectoryRepository>(
  (_) => const DemoDirectoryRepository(),
);
final proposalRepositoryProvider = Provider<ProposalRepository>(
  (_) => const DemoProposalRepository(),
);
final emergencyRepositoryProvider = Provider<EmergencyRepository>(
  (ref) => DriftEmergencyRepository(ref.watch(appDatabaseProvider)),
);
final dealRepositoryProvider = Provider<DealRepository>(
  (ref) => DriftDealRepository(ref.watch(appDatabaseProvider)),
);
final reputationRepositoryProvider = Provider<ReputationRepository>(
  (ref) => DriftReputationRepository(ref.watch(appDatabaseProvider)),
);

// --- Casos de uso ---
final publishNeedProvider = Provider<PublishNeed>(
  (ref) => PublishNeed(
    needs: ref.watch(needRepositoryProvider),
    outbox: ref.watch(outboxProvider),
    clock: ref.watch(clockProvider),
    ids: ref.watch(idGeneratorProvider),
  ),
);

final flushOutboxProvider = Provider<FlushOutbox>(
  (ref) => FlushOutbox(
    outbox: ref.watch(outboxProvider),
    gateway: ref.watch(syncGatewayProvider),
    connectivity: ref.watch(connectivityProvider),
    needs: ref.watch(needRepositoryProvider),
    emergency: ref.watch(emergencyRepositoryProvider),
  ),
);

final publishSosProvider = Provider<PublishSos>(
  (ref) => PublishSos(
    posts: ref.watch(emergencyRepositoryProvider),
    outbox: ref.watch(outboxProvider),
    clock: ref.watch(clockProvider),
    ids: ref.watch(idGeneratorProvider),
  ),
);

final exploreNearbyProvider = Provider<ExploreNearby>(
  (ref) => ExploreNearby(
    directory: ref.watch(directoryRepositoryProvider),
    reputation: ref.watch(reputationRepositoryProvider),
  ),
);

final listProposalsProvider = Provider<ListProposals>(
  (ref) => ListProposals(ref.watch(proposalRepositoryProvider)),
);

final acceptProposalProvider = Provider<AcceptProposal>(
  (ref) => AcceptProposal(
    deals: ref.watch(dealRepositoryProvider),
    clock: ref.watch(clockProvider),
    ids: ref.watch(idGeneratorProvider),
  ),
);

final postResponseRepositoryProvider = Provider<PostResponseRepository>(
  (ref) => DriftPostResponseRepository(ref.watch(appDatabaseProvider)),
);

final postResponsesStreamProvider = StreamProvider<List<PostResponse>>(
  (ref) => ref.watch(postResponseRepositoryProvider).watchAll(),
);

final sendPostResponseProvider = Provider<SendPostResponse>(
  (ref) => SendPostResponse(
    repo: ref.watch(postResponseRepositoryProvider),
    clock: ref.watch(clockProvider),
    ids: ref.watch(idGeneratorProvider),
  ),
);

final negotiationRepositoryProvider = Provider<NegotiationRepository>(
  (ref) => DriftNegotiationRepository(ref.watch(appDatabaseProvider)),
);

final negotiationsStreamProvider = StreamProvider<List<OfferVersion>>(
  (ref) => ref.watch(negotiationRepositoryProvider).watchAll(),
);

final priceChangeRepositoryProvider = Provider<PriceChangeRepository>(
  (ref) => DriftPriceChangeRepository(ref.watch(appDatabaseProvider)),
);

final priceChangesStreamProvider = StreamProvider<List<PriceChange>>(
  (ref) => ref.watch(priceChangeRepositoryProvider).watchAll(),
);

final counterOfferProvider = Provider<CounterOfferService>(
  (ref) => CounterOfferService(
    deals: ref.watch(dealRepositoryProvider),
    changes: ref.watch(priceChangeRepositoryProvider),
    clock: ref.watch(clockProvider),
    ids: ref.watch(idGeneratorProvider),
  ),
);

final cancelDealProvider = Provider<CancelDeal>(
  (ref) => CancelDeal(
    deals: ref.watch(dealRepositoryProvider),
    clock: ref.watch(clockProvider),
  ),
);

final rateParticipantProvider = Provider<RateParticipant>(
  (ref) => RateParticipant(
    deals: ref.watch(dealRepositoryProvider),
    reputation: ref.watch(reputationRepositoryProvider),
    clock: ref.watch(clockProvider),
    ids: ref.watch(idGeneratorProvider),
  ),
);

final closeWithoutRatingProvider = Provider<CloseWithoutRating>(
  (ref) => CloseWithoutRating(deals: ref.watch(dealRepositoryProvider)),
);

final negotiateProvider = Provider<Negotiate>(
  (ref) => Negotiate(
    repo: ref.watch(negotiationRepositoryProvider),
    accept: ref.watch(acceptProposalProvider),
    clock: ref.watch(clockProvider),
    ids: ref.watch(idGeneratorProvider),
  ),
);

final validateMeetingCodeProvider = Provider<ValidateMeetingCode>(
  (ref) => ValidateMeetingCode(
    deals: ref.watch(dealRepositoryProvider),
    clock: ref.watch(clockProvider),
  ),
);

final completeDealProvider = Provider<CompleteDeal>(
  (ref) => CompleteDeal(
    deals: ref.watch(dealRepositoryProvider),
    clock: ref.watch(clockProvider),
  ),
);

final closeAndRateProvider = Provider<CloseAndRate>(
  (ref) => CloseAndRate(
    deals: ref.watch(dealRepositoryProvider),
    reputation: ref.watch(reputationRepositoryProvider),
    directory: ref.watch(directoryRepositoryProvider),
    clock: ref.watch(clockProvider),
    ids: ref.watch(idGeneratorProvider),
  ),
);

// --- Flujos de datos observables ---
final needsStreamProvider = StreamProvider<List<Need>>(
  (ref) => ref.watch(needRepositoryProvider).watchAll(),
);
final dealsStreamProvider = StreamProvider<List<Deal>>(
  (ref) => ref.watch(dealRepositoryProvider).watchAll(),
);
final interactionsStreamProvider = StreamProvider<List<Interaction>>(
  (ref) => ref.watch(reputationRepositoryProvider).watchAll(),
);

final emergencyPostsStreamProvider = StreamProvider<List<EmergencyPost>>(
  (ref) => ref.watch(emergencyRepositoryProvider).watchAll(),
);

// --- Lado proveedor ---
final providerRepositoryProvider = Provider<ProviderRepository>(
  (ref) => DriftProviderRepository(ref.watch(appDatabaseProvider)),
);
final jobBoardProvider = Provider<JobBoard>((_) => const DemoJobBoard());
final publishServiceOfferProvider = Provider<PublishServiceOffer>(
  (ref) => PublishServiceOffer(
    repo: ref.watch(providerRepositoryProvider),
    clock: ref.watch(clockProvider),
    ids: ref.watch(idGeneratorProvider),
  ),
);
final sendJobProposalProvider = Provider<SendJobProposal>(
  (ref) => SendJobProposal(
    repo: ref.watch(providerRepositoryProvider),
    clock: ref.watch(clockProvider),
  ),
);
final offersStreamProvider = StreamProvider<List<ServiceOffer>>(
  (ref) => ref.watch(providerRepositoryProvider).watchOffers(),
);
final jobProposalsStreamProvider = StreamProvider<List<JobProposal>>(
  (ref) => ref.watch(providerRepositoryProvider).watchProposals(),
);

/// Pedidos de ejemplo que coinciden con lo que haces (sin repetir).
final jobRequestsProvider = FutureProvider<List<JobRequest>>((ref) async {
  final offers =
      ref.watch(offersStreamProvider).value ?? const <ServiceOffer>[];
  final board = ref.watch(jobBoardProvider);
  final out = <String, JobRequest>{};
  for (final o in offers) {
    for (final j in await board.requestsFor(o.trade)) {
      out[j.id] = j;
    }
  }
  return out.values.toList();
});

// --- Estado de conexión para toda la app ---
final onlineProvider = StreamProvider<bool>((ref) async* {
  final c = ref.watch(connectivityProvider);
  yield await c.isOnline;
  yield* c.onlineChanges;
});

/// Cuántas cosas están guardadas en el teléfono esperando enviarse (los casos privados nunca se envían).
final pendingCountProvider = Provider<int>((ref) {
  final needs = ref.watch(needsStreamProvider).value ?? const <Need>[];
  final posts =
      ref.watch(emergencyPostsStreamProvider).value ?? const <EmergencyPost>[];
  return needs.where((n) => n.syncStatus == SyncStatus.pending).length +
      posts
          .where((p) => !p.isPrivate && p.syncStatus == SyncStatus.pending)
          .length;
});

// --- Chat del trato, ventas y ofertas al barrio ---
final dealChatProvider = Provider<DealChatGateway>(
  (ref) => DriftDealChat(ref.watch(appDatabaseProvider)),
);
final sendChatMessageProvider = Provider<SendChatMessage>(
  (ref) => SendChatMessage(
    gateway: ref.watch(dealChatProvider),
    connectivity: ref.watch(connectivityProvider),
    clock: ref.watch(clockProvider),
    ids: ref.watch(idGeneratorProvider),
  ),
);
final chatMessagesProvider = StreamProvider.family<List<ChatMessage>, String>(
  (ref, dealId) => ref.watch(dealChatProvider).watch(dealId),
);
final chatReadsProvider = StreamProvider<Map<String, DateTime>>(
  (ref) => ref.watch(dealChatProvider).watchReads(),
);

/// Total de mensajes sin leer (datos reales: mensajes recibidos después de tu última lectura).
final unreadTotalProvider = Provider<int>((ref) {
  final all = ref.watch(allChatMessagesProvider).value ?? const <ChatMessage>[];
  final reads =
      ref.watch(chatReadsProvider).value ?? const <String, DateTime>{};
  final byDeal = <String, List<ChatMessage>>{};
  for (final m in all) {
    byDeal.putIfAbsent(m.dealId, () => []).add(m);
  }
  var total = 0;
  byDeal.forEach((id, list) => total += unreadCount(list, reads[id]));
  return total;
});

final allChatMessagesProvider = StreamProvider<List<ChatMessage>>(
  (ref) => ref.watch(dealChatProvider).watchAll(),
);

final marketRepositoryProvider = Provider<MarketRepository>(
  (ref) => DriftMarketRepository(ref.watch(appDatabaseProvider)),
);
final publishProductSaleProvider = Provider<PublishProductSale>(
  (ref) => PublishProductSale(
    repo: ref.watch(marketRepositoryProvider),
    clock: ref.watch(clockProvider),
    ids: ref.watch(idGeneratorProvider),
  ),
);
final decideBuyerOfferProvider = Provider<DecideBuyerOffer>(
  (ref) => DecideBuyerOffer(ref.watch(marketRepositoryProvider)),
);
final publishWallOfferProvider = Provider<PublishWallOffer>(
  (ref) => PublishWallOffer(
    repo: ref.watch(marketRepositoryProvider),
    clock: ref.watch(clockProvider),
    ids: ref.watch(idGeneratorProvider),
  ),
);
final salesStreamProvider = StreamProvider<List<ProductSale>>(
  (ref) => ref.watch(marketRepositoryProvider).watchSales(),
);
final wallOffersStreamProvider = StreamProvider<List<WallOffer>>(
  (ref) => ref.watch(marketRepositoryProvider).watchWallOffers(),
);
