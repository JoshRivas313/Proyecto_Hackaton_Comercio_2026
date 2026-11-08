import 'package:flutter_test/flutter_test.dart';
import 'package:red_barrio/core/result.dart';
import 'package:red_barrio/features/deals_chat/domain/chat.dart';
import 'package:red_barrio/features/solidarity/domain/market.dart';

import '../fakes/fakes.dart';

class FakeMarket implements MarketRepository {
  final sales = <String, ProductSale>{};
  final offers = <WallOffer>[];

  @override
  Future<Result<void>> saveSale(ProductSale sale) async {
    sales[sale.id] = sale;
    return const Ok(null);
  }

  @override
  Future<ProductSale?> saleById(String id) async => sales[id];
  @override
  Stream<List<ProductSale>> watchSales() => Stream.value(sales.values.toList());
  @override
  Future<Result<void>> saveWallOffer(WallOffer offer) async {
    offers.add(offer);
    return const Ok(null);
  }

  @override
  Stream<List<WallOffer>> watchWallOffers() => Stream.value(offers);
}

class FakeChat implements DealChatGateway {
  final sent = <ChatMessage>[];
  bool? lastOnline;
  @override
  Future<Result<void>> send(ChatMessage message, {required bool online}) async {
    sent.add(message);
    lastOnline = online;
    return const Ok(null);
  }

  @override
  Stream<List<ChatMessage>> watch(String dealId) => Stream.value(sent);
  @override
  Stream<List<ChatMessage>> watchAll() => Stream.value(sent);
  @override
  Future<void> markRead(String dealId, DateTime at) async {}
  @override
  Stream<Map<String, DateTime>> watchReads() => Stream.value({});
}

void main() {
  final clock = FakeClock(DateTime(2026, 11, 8));

  group('vender un producto', () {
    test('exige descripción y precio válido', () async {
      final uc = PublishProductSale(
        repo: FakeMarket(),
        clock: clock,
        ids: FakeIds(),
      );
      expect(await uc('', '120'), isA<Err<ProductSale>>());
      expect(await uc('Bicicleta', ''), isA<Err<ProductSale>>());
      expect(await uc('Bicicleta', '0'), isA<Err<ProductSale>>());
      expect((await uc('Bicicleta de paseo', 'S/ 120')).isOk, isTrue);
    });

    test('hay 3 ofertas de ejemplo: lista, 80 % y 60 %', () {
      final sale = ProductSale(
        id: 'a',
        text: 'x',
        priceSoles: 100,
        createdAt: clock.now(),
      );
      final o = buyerOffersFor(sale);
      expect(o.map((e) => e.priceSoles), [100, 80, 60]);
      expect(o.first.atListPrice, isTrue);
    });

    test('aceptar cierra la venta; rechazar quita la oferta; no se acepta dos veces', () async {
      final repo = FakeMarket();
      final sale = ProductSale(
        id: 's1',
        text: 'x',
        priceSoles: 100,
        createdAt: clock.now(),
      );
      await repo.saveSale(sale);
      final decide = DecideBuyerOffer(repo);
      await decide.reject('s1', 0);
      expect(repo.sales['s1']!.rejected, {0});
      expect(await decide.accept('s1', 0), isA<Err<void>>());
      expect((await decide.accept('s1', 1)).isOk, isTrue);
      expect(repo.sales['s1']!.sold, isTrue);
      expect(repo.sales['s1']!.soldPrice, 80);
      expect(await decide.accept('s1', 2), isA<Err<void>>());
    });
  });

  group('ofrecer al barrio', () {
    test('exige modalidad válida y texto', () async {
      final uc = PublishWallOffer(
        repo: FakeMarket(),
        clock: clock,
        ids: FakeIds(),
      );
      expect(await uc(null, 'Presto una escalera'), isA<Err<WallOffer>>());
      expect(
        await uc('Inventada', 'Presto una escalera'),
        isA<Err<WallOffer>>(),
      );
      expect(await uc('Préstamo', 'ab'), isA<Err<WallOffer>>());
      expect((await uc('Préstamo', 'Presto una escalera')).isOk, isTrue);
    });
  });

  group('chat del trato', () {
    test('rechaza vacío o demasiado largo y no guarda nada', () async {
      final chat = FakeChat();
      final uc = SendChatMessage(
        gateway: chat,
        connectivity: FakeConnectivity(),
        clock: clock,
        ids: FakeIds(),
      );
      expect(await uc('d', '   '), isA<Err<void>>());
      expect(await uc('d', 'a' * 301), isA<Err<void>>());
      expect(chat.sent, isEmpty);
    });

    test(
      'envía y avisa si hay internet (para la respuesta de ejemplo)',
      () async {
        final chat = FakeChat();
        final net = FakeConnectivity();
        final uc = SendChatMessage(
          gateway: chat,
          connectivity: net,
          clock: clock,
          ids: FakeIds(),
        );
        await uc('d', ' Hola ');
        expect(chat.sent.single.text, 'Hola');
        expect(chat.sent.single.fromMe, isTrue);
        expect(chat.lastOnline, isTrue);
        net.online = false;
        await uc('d', 'Otra vez');
        expect(chat.lastOnline, isFalse);
      },
    );
  });
}
