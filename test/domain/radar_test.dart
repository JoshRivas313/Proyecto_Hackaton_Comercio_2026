import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:red_barrio/features/directory/domain/listing.dart';
import 'package:red_barrio/features/directory/domain/provider_profile.dart';
import 'package:red_barrio/features/explore/domain/explore_nearby.dart';
import 'package:red_barrio/features/explore/domain/radar.dart';
import 'package:red_barrio/features/reputation/domain/visto_bueno.dart';

ExploreItem _item(
  String id, {
  double? meters,
  bool real = false,
  bool example = true,
  double? lat,
  double? lng,
}) => ExploreItem(
  listing: Listing(
    id: id,
    providerId: 'p',
    title: 'Servicio',
    trade: 'Gasfitería',
    kind: ListingKind.service,
    availability: 'Hoy',
    reference: '',
    requestText: '',
    latitude: lat,
    longitude: lng,
    isExample: example,
  ),
  provider: const ProviderProfile(
    id: 'p',
    name: 'Prestador',
    role: 'Gasfitero',
    exampleRating: 4.5,
    exampleRatingCount: 10,
    exampleVistoBueno: 3,
  ),
  distanceMeters: meters,
  distanceIsReal: real,
  vistoBueno: const VistoBueno(confirmed: 0, example: 0),
  recommendedByMe: false,
);

void main() {
  group('anillos', () {
    test('cada distancia cae en su anillo', () {
      expect(ringOf(_item('a', meters: 100)), 0);
      expect(
        ringOf(_item('a', meters: 250)),
        1,
      ); // 250 m ya es el siguiente anillo
      expect(ringOf(_item('a', meters: 499)), 1);
      expect(ringOf(_item('a', meters: 700)), 2);
      expect(ringOf(_item('a', meters: 999)), 3);
      expect(ringOf(_item('a', meters: 1500)), radarRings.length);
    });

    test(
      'sin distancia conocida va a «más de 1 km», no a un anillo inventado',
      () {
        expect(ringOf(_item('a')), radarRings.length);
      },
    );

    test('se agrupa por anillo y se conserva a todos', () {
      final items = [
        _item('a', meters: 100),
        _item('b', meters: 300),
        _item('c', meters: 320),
        _item('d', meters: 2000),
      ];
      final g = groupByRing(items);
      expect(g.length, radarRings.length + 1);
      expect(g[0].map((i) => i.listing.id), ['a']);
      expect(g[1].map((i) => i.listing.id), ['b', 'c']);
      expect(g[radarRings.length].map((i) => i.listing.id), ['d']);
      expect(g.expand((x) => x).length, items.length);
    });

    test('al abrir se elige el primer anillo con recursos', () {
      expect(firstNonEmptyRing(groupByRing([_item('a', meters: 600)])), 2);
      expect(firstNonEmptyRing(groupByRing(const [])), 0);
    });
  });

  group('posición real (nunca inventada)', () {
    test(
      'solo hay posición con coordenadas válidas y que no sean de prueba',
      () {
        expect(hasRealPosition(_item('a', meters: 100)), isFalse);
        expect(
          hasRealPosition(_item('a', meters: 100, real: true, lat: 1, lng: 1)),
          isFalse, // sigue siendo de prueba
        );
        expect(
          hasRealPosition(
            _item('a', meters: 100, real: true, example: false, lat: 1, lng: 1),
          ),
          isTrue,
        );
        expect(
          hasRealPosition(_item('a', meters: 100, real: true, example: false)),
          isFalse, // sin coordenadas
        );
      },
    );

    test('un recurso al norte tiene rumbo 0 y uno al este, 90°', () {
      final north = realPosition(
        _item('n', meters: 500, lat: -12.0, lng: -77.0),
        -12.01,
        -77.0,
      );
      expect(north.bearing, closeTo(0, 1e-6));
      final east = realPosition(
        _item('e', meters: 500, lat: -12.0, lng: -76.99),
        -12.0,
        -77.0,
      );
      expect(east.bearing, closeTo(math.pi / 2, 1e-3));
    });

    test('la distancia se acota para que siempre sea visible en el radar', () {
      final far = realPosition(_item('f', meters: 5000, lat: 1, lng: 1), 0, 0);
      expect(far.fraction, 1.0);
      final near = realPosition(_item('c', meters: 1, lat: 1, lng: 1), 0, 0);
      expect(near.fraction, 0.1);
    });
  });
}
