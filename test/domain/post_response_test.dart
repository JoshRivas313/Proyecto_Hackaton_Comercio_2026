import 'package:flutter_test/flutter_test.dart';
import 'package:red_barrio/core/result.dart';
import 'package:red_barrio/features/solidarity/domain/post_response.dart';
import 'package:red_barrio/features/solidarity/domain/wall_demo.dart';

import '../fakes/fakes.dart';

class FakeResponses implements PostResponseRepository {
  final Map<String, PostResponse> store = {};

  @override
  Future<Result<void>> save(PostResponse r) async {
    store[r.id] = r;
    return const Ok(null);
  }

  @override
  Future<PostResponse?> byPostKey(String key) async =>
      store.values.where((r) => r.postKey == key).firstOrNull;

  @override
  Stream<List<PostResponse>> watchAll() => Stream.value(store.values.toList());
}

WallItem _w(String mode) => WallItem('Ana', 'Algo', '200 m', mode);

void main() {
  group('tipo e intención', () {
    test('un pedido de préstamo no es una oferta ni un favor', () {
      expect(
        classifyWallItem(_w('Préstamo'), isRequest: true),
        PostKind.loanRequest,
      );
      expect(
        classifyWallItem(_w('Préstamo'), isRequest: false),
        PostKind.loanOffer,
      );
    });

    test('favores, donaciones y trueques se distinguen', () {
      expect(
        classifyWallItem(_w('Favor'), isRequest: true),
        PostKind.favorRequest,
      );
      expect(
        classifyWallItem(_w('Donación'), isRequest: false),
        PostKind.donationOffer,
      );
      expect(classifyWallItem(_w('Trueque'), isRequest: true), PostKind.barter);
      expect(
        classifyWallItem(_w('Intercambio de habilidades'), isRequest: false),
        PostKind.barter,
      );
    });
  });

  group('acción contextual', () {
    test('cada tipo tiene su botón', () {
      expect(actionLabel(PostKind.serviceRequest), 'Proponer mi servicio');
      expect(actionLabel(PostKind.productRequest), 'Ofrecer producto');
      expect(actionLabel(PostKind.productSale), 'Me interesa');
      expect(actionLabel(PostKind.loanRequest), 'Puedo prestártelo');
      expect(actionLabel(PostKind.favorRequest), 'Quiero ayudar');
      expect(actionLabel(PostKind.donationOffer), 'Solicitar donación');
      expect(actionLabel(PostKind.barter), 'Proponer intercambio');
      expect(actionLabel(PostKind.emergency), 'Ofrecer apoyo');
      // Ningún tipo usa el genérico.
      expect(
        PostKind.values.map(actionLabel),
        everyElement(isNot('Ofrecer mi ayuda')),
      );
    });
  });

  group('formularios adaptativos', () {
    test('el dinero solo aparece en servicios y productos', () {
      for (final k in PostKind.values) {
        final hasPrice = fieldsFor(k).contains(ResponseField.price);
        final commercial = {
          PostKind.serviceRequest,
          PostKind.productRequest,
          PostKind.productSale,
        }.contains(k);
        expect(hasPrice, commercial, reason: '$k');
      }
    });

    test('cada tipo muestra los campos pertinentes', () {
      expect(fieldsFor(PostKind.loanRequest), [
        ResponseField.availability,
        ResponseField.duration,
        ResponseField.conditions,
      ]);
      expect(fieldsFor(PostKind.barter), [
        ResponseField.offeredResource,
        ResponseField.conditions,
      ]);
      expect(fieldsFor(PostKind.donationOffer), [
        ResponseField.quantity,
        ResponseField.coordination,
      ]);
      expect(fieldsFor(PostKind.emergency), [
        ResponseField.availability,
        ResponseField.coordination,
      ]);
    });

    test('formato de precios', () {
      expect(formatSoles(40), 'S/ 40');
      expect(formatSoles(12.5), 'S/ 12.50');
    });
  });

  group('envío de propuestas', () {
    late FakeResponses repo;
    late SendPostResponse send;
    setUp(() {
      repo = FakeResponses();
      send = SendPostResponse(
        repo: repo,
        clock: FakeClock(DateTime(2026, 11, 8)),
        ids: FakeIds(),
      );
    });

    test('un servicio exige precio y disponibilidad', () async {
      final item = _w('Favor');
      expect(
        await send(item, PostKind.serviceRequest, {ResponseField.price: ''}),
        isA<Err<dynamic>>(),
      );
      final ok = await send(item, PostKind.serviceRequest, {
        ResponseField.price: '40',
        ResponseField.availability: 'Hoy',
      });
      expect(ok.isOk, isTrue);
      expect((ok as Ok<PostResponse>).value.values['price'], '40');
    });

    test('un préstamo se responde sin dinero', () async {
      final r = await send(_w('Préstamo'), PostKind.loanRequest, {
        ResponseField.availability: 'Esta tarde',
        ResponseField.duration: '2 días',
      });
      expect(r.isOk, isTrue);
      expect(
        (r as Ok<PostResponse>).value.values.containsKey('price'),
        isFalse,
      );
    });

    test('no se puede responder dos veces a la misma publicación', () async {
      final item = _w('Favor');
      final first = await send(item, PostKind.favorRequest, {
        ResponseField.availability: 'Hoy',
      });
      final second = await send(item, PostKind.favorRequest, {
        ResponseField.availability: 'Mañana',
      });
      expect(first.isOk, isTrue);
      expect(second, isA<Err<dynamic>>());
      expect(repo.store.length, 1);
    });

    test('un trueque exige lo que se ofrece a cambio', () async {
      expect(
        await send(_w('Trueque'), PostKind.barter, {}),
        isA<Err<dynamic>>(),
      );
      expect(
        (await send(_w('Trueque'), PostKind.barter, {
          ResponseField.offeredResource: 'Clases de inglés',
        })).isOk,
        isTrue,
      );
    });

    test('el resumen muestra los precios con formato', () async {
      final r = await send(_w('Favor'), PostKind.productSale, {
        ResponseField.price: '35',
        ResponseField.quantity: '2',
      });
      expect((r as Ok<PostResponse>).value.summary, contains('S/ 35'));
    });
  });
}
