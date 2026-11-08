import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Necesidades publicadas por esta persona (copia local).
@DataClassName('NeedRow')
class Needs extends Table {
  TextColumn get id => text()();
  TextColumn get kind => text()();
  TextColumn get body => text()();
  TextColumn get urgency => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get syncStatus => text()();
  TextColumn get details => text().nullable()();
  TextColumn get photoPath => text().nullable()();
  TextColumn get categoryId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Cola de pendientes. La clave primaria es el UUID de cliente: encolar dos veces no duplica.
@DataClassName('OutboxRow')
class OutboxOps extends Table {
  TextColumn get id => text()();
  TextColumn get opType => text()();
  TextColumn get payload => text()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get lastError => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Tratos (propuesta aceptada → código → servicio → calificación). Desde el esquema 2.
@DataClassName('DealRow')
class Deals extends Table {
  TextColumn get id => text()();
  TextColumn get needId => text()();
  TextColumn get providerId => text()();
  TextColumn get providerName => text()();
  IntColumn get priceSoles => integer()();
  TextColumn get priceLabel => text()();
  TextColumn get code => text()();
  TextColumn get status => text()();
  DateTimeColumn get acceptedAt => dateTime()();
  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Tratos cerrados y calificados: única fuente de reputación y Visto Bueno reales. Desde el esquema 2.
@DataClassName('InteractionRow')
class Interactions extends Table {
  TextColumn get id => text()();
  TextColumn get dealId => text()();
  TextColumn get providerId => text()();
  TextColumn get raterId => text()();
  IntColumn get stars => integer()();
  BoolColumn get recommended => boolean()();
  DateTimeColumn get closedAt => dateTime()();
  TextColumn get comment => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Pedidos de ayuda en emergencia (copia local). Desde el esquema 3.
@DataClassName('EmergencyRow')
class EmergencyPosts extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  TextColumn get why => text()();
  TextColumn get needs => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get syncStatus => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Oficios que esta persona ofrece (sin precio). Desde el esquema 4.
@DataClassName('ServiceOfferRow')
class ServiceOffers extends Table {
  TextColumn get id => text()();
  TextColumn get trade => text()();
  TextColumn get availability => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Propuestas de precio enviadas a pedidos (una por pedido). Desde el esquema 4.
@DataClassName('JobProposalRow')
class JobProposals extends Table {
  TextColumn get jobId => text()();
  IntColumn get priceSoles => integer()();
  DateTimeColumn get sentAt => dateTime()();

  @override
  Set<Column> get primaryKey => {jobId};
}

/// Mensajes del chat del trato. Desde el esquema 5.
@DataClassName('ChatMessageRow')
class ChatMessages extends Table {
  TextColumn get id => text()();
  TextColumn get dealId => text()();
  BoolColumn get fromMe => boolean()();
  TextColumn get body => text()();
  BoolColumn get isExample => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Productos que vendo. Desde el esquema 5.
@DataClassName('ProductSaleRow')
class ProductSales extends Table {
  TextColumn get id => text()();
  TextColumn get body => text()();
  IntColumn get priceSoles => integer()();
  BoolColumn get sold => boolean().withDefault(const Constant(false))();
  IntColumn get soldPrice => integer().nullable()();
  TextColumn get soldTo => text().nullable()();
  TextColumn get rejected => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get photoPath => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Historial de negociación: una fila por versión de las condiciones. Desde el esquema 10.
@DataClassName('OfferVersionRow')
class NegotiationOffers extends Table {
  TextColumn get id => text()();
  TextColumn get needId => text()();
  TextColumn get providerId => text()();
  BoolColumn get byClient => boolean()();
  IntColumn get priceSoles => integer()();
  TextColumn get priceLabel => text()();
  TextColumn get conditions => text().nullable()();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Respuestas que envío a publicaciones del muro. Desde el esquema 11.
@DataClassName('PostResponseRow')
class PostResponses extends Table {
  TextColumn get id => text()();
  TextColumn get postKey => text()();
  TextColumn get kind => text()();
  TextColumn get valuesJson => text()();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Última vez que abriste cada conversación (para contar mensajes sin leer).
class ChatReads extends Table {
  TextColumn get dealId => text()();
  DateTimeColumn get readAt => dateTime()();

  @override
  Set<Column> get primaryKey => {dealId};
}

/// Ofertas que hago al barrio (sin dinero). Desde el esquema 5.
@DataClassName('WallOfferRow')
class WallOffers extends Table {
  TextColumn get id => text()();
  TextColumn get mode => text()();
  TextColumn get body => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Needs,
    OutboxOps,
    Deals,
    Interactions,
    EmergencyPosts,
    ServiceOffers,
    JobProposals,
    ChatMessages,
    ProductSales,
    WallOffers,
    ChatReads,
    NegotiationOffers,
    PostResponses,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  /// Base real en el teléfono.
  AppDatabase.open() : super(driftDatabase(name: 'red_barrio'));

  /// Versión del esquema. Cada cambio exige subirla y escribir su migración + prueba (R28).
  /// 1: needs, outbox_ops · 2: + deals, interactions · 3: + emergency_posts · 4: + service_offers, job_proposals
  @override
  int get schemaVersion => 11;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(deals);
        await m.createTable(interactions);
      }
      if (from < 3) {
        await m.createTable(emergencyPosts);
      }
      if (from < 4) {
        await m.createTable(serviceOffers);
        await m.createTable(jobProposals);
      }
      if (from < 5) {
        await m.createTable(chatMessages);
        await m.createTable(productSales);
        await m.createTable(wallOffers);
      }
      if (from == 5) {
        await m.addColumn(productSales, productSales.photoPath);
      }
      if (from < 11) {
        await m.createTable(postResponses);
      }
      if (from < 10) {
        await m.createTable(negotiationOffers);
      }
      if (from < 9) {
        await m.addColumn(needs, needs.categoryId);
      }
      if (from < 8) {
        await m.createTable(chatReads);
      }
      if (from < 7) {
        await m.addColumn(needs, needs.details);
        await m.addColumn(needs, needs.photoPath);
      }
    },
  );
}
