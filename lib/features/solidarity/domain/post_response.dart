import 'dart:convert';

import '../../../core/clock.dart';
import '../../../core/failure.dart';
import '../../../core/ids.dart';
import '../../../core/result.dart';
import 'wall_demo.dart';

/// Tipo + intención de una publicación del muro. No toda publicación es «una solicitud de ayuda».
enum PostKind {
  serviceRequest,
  productRequest,
  productSale,
  loanRequest,
  loanOffer,
  favorRequest,
  favorOffer,
  donationOffer,
  barter,
  emergency,
}

/// Clasifica una publicación del muro según su modalidad y si es pedido u oferta.
PostKind classifyWallItem(WallItem item, {required bool isRequest}) {
  switch (item.mode) {
    case 'Préstamo':
    case 'Alquiler':
      return isRequest ? PostKind.loanRequest : PostKind.loanOffer;
    case 'Trueque':
    case 'Intercambio de habilidades':
      return PostKind.barter;
    case 'Donación':
      return isRequest ? PostKind.favorRequest : PostKind.donationOffer;
    case 'Favor':
    case 'Movilidad solidaria':
      return isRequest ? PostKind.favorRequest : PostKind.favorOffer;
    default:
      return isRequest ? PostKind.favorRequest : PostKind.favorOffer;
  }
}

/// Texto del botón principal de cada publicación.
String actionLabel(PostKind k) => switch (k) {
  PostKind.serviceRequest => 'Proponer mi servicio',
  PostKind.productRequest => 'Ofrecer producto',
  PostKind.productSale => 'Me interesa',
  PostKind.loanRequest => 'Puedo prestártelo',
  PostKind.loanOffer => 'Solicitar préstamo',
  PostKind.favorRequest => 'Quiero ayudar',
  PostKind.favorOffer => 'Pedir ayuda',
  PostKind.donationOffer => 'Solicitar donación',
  PostKind.barter => 'Proponer intercambio',
  PostKind.emergency => 'Ofrecer apoyo',
};

/// Campos que puede mostrar el formulario de respuesta.
enum ResponseField {
  price,
  quantity,
  availability,
  delivery,
  duration,
  conditions,
  offeredResource,
  coordination,
  message,
}

String fieldLabel(ResponseField f) => switch (f) {
  ResponseField.price => 'Tu precio (S/)',
  ResponseField.quantity => 'Cantidad',
  ResponseField.availability => 'Disponibilidad',
  ResponseField.delivery => 'Entrega',
  ResponseField.duration => 'Duración',
  ResponseField.conditions => 'Condiciones',
  ResponseField.offeredResource => 'Qué ofreces a cambio',
  ResponseField.coordination => 'Cómo coordinamos',
  ResponseField.message => 'Mensaje (opcional)',
};

String fieldHint(ResponseField f) => switch (f) {
  ResponseField.price => 'Ej.: 40',
  ResponseField.quantity => 'Ej.: 2',
  ResponseField.availability => 'Ej.: hoy en la tarde',
  ResponseField.delivery => 'Ej.: te lo llevo / lo recoges',
  ResponseField.duration => 'Ej.: 2 días',
  ResponseField.conditions => 'Ej.: lo devuelves limpio',
  ResponseField.offeredResource => 'Ej.: clases de inglés',
  ResponseField.coordination => 'Ej.: nos vemos en la plaza',
  ResponseField.message => '',
};

/// Campos pertinentes por tipo (solo los que tienen sentido). El dinero solo aparece donde
/// hay compra, venta o servicio: nunca en préstamos, favores, donaciones ni trueques.
List<ResponseField> fieldsFor(PostKind k) => switch (k) {
  PostKind.serviceRequest => [
    ResponseField.price,
    ResponseField.availability,
    ResponseField.message,
  ],
  PostKind.productRequest => [
    ResponseField.quantity,
    ResponseField.price,
    ResponseField.delivery,
    ResponseField.message,
  ],
  PostKind.productSale => [
    ResponseField.quantity,
    ResponseField.price,
    ResponseField.delivery,
    ResponseField.message,
  ],
  PostKind.loanRequest => [
    ResponseField.availability,
    ResponseField.duration,
    ResponseField.conditions,
  ],
  PostKind.loanOffer => [
    ResponseField.duration,
    ResponseField.coordination,
    ResponseField.message,
  ],
  PostKind.favorRequest => [ResponseField.availability, ResponseField.message],
  PostKind.favorOffer => [ResponseField.availability, ResponseField.message],
  PostKind.donationOffer => [
    ResponseField.quantity,
    ResponseField.coordination,
  ],
  PostKind.barter => [ResponseField.offeredResource, ResponseField.conditions],
  PostKind.emergency => [
    ResponseField.availability,
    ResponseField.coordination,
  ],
};

/// Campos obligatorios (los demás son opcionales).
List<ResponseField> requiredFor(PostKind k) => switch (k) {
  PostKind.serviceRequest => [ResponseField.price, ResponseField.availability],
  PostKind.productRequest => [ResponseField.price],
  PostKind.productSale => const [],
  PostKind.loanRequest => [ResponseField.availability],
  PostKind.loanOffer => const [],
  PostKind.favorRequest => [ResponseField.availability],
  PostKind.favorOffer => const [],
  PostKind.donationOffer => const [],
  PostKind.barter => [ResponseField.offeredResource],
  PostKind.emergency => [ResponseField.availability],
};

/// «S/ 40» (sin decimales innecesarios).
String formatSoles(num n) =>
    n == n.roundToDouble() ? 'S/ ${n.round()}' : 'S/ ${n.toStringAsFixed(2)}';

/// Respuesta enviada a una publicación.
class PostResponse {
  const PostResponse({
    required this.id,
    required this.postKey,
    required this.kind,
    required this.values,
    required this.createdAt,
    this.status = 'sent',
  });

  final String id;

  /// Identifica la publicación respondida (evita enviar dos veces la misma).
  final String postKey;
  final PostKind kind;
  final Map<String, String> values;
  final DateTime createdAt;

  /// `sent` = propuesta enviada, a la espera de respuesta del autor.
  final String status;

  String get valuesJson => jsonEncode(values);

  /// Resumen legible para mostrar al consultar el estado.
  String get summary => [
    for (final e in values.entries)
      if (e.value.isNotEmpty)
        '${fieldLabel(ResponseField.values.byName(e.key)).replaceAll(' (opcional)', '')}: ${e.key == 'price' ? formatSoles(int.tryParse(e.value) ?? 0) : e.value}',
  ].join('\n');
}

/// Clave estable de una publicación del muro.
String postKeyOf(WallItem item) => '${item.who}|${item.text}';

abstract interface class PostResponseRepository {
  Future<Result<void>> save(PostResponse r);
  Future<PostResponse?> byPostKey(String postKey);
  Stream<List<PostResponse>> watchAll();
}

/// Envía la respuesta a una publicación: valida según el tipo y evita duplicados.
class SendPostResponse {
  SendPostResponse({
    required this.repo,
    required this.clock,
    required this.ids,
  });

  final PostResponseRepository repo;
  final Clock clock;
  final IdGenerator ids;

  Future<Result<PostResponse>> call(
    WallItem item,
    PostKind kind,
    Map<ResponseField, String> input,
  ) async {
    final values = <String, String>{};
    for (final f in fieldsFor(kind)) {
      final v = (input[f] ?? '').trim();
      if (requiredFor(kind).contains(f) && v.isEmpty) {
        return Err(
          ValidationFailure(
            'Completa «${fieldLabel(f).replaceAll(' (S/)', '')}».',
          ),
        );
      }
      if (f == ResponseField.price && v.isNotEmpty) {
        final n = int.tryParse(RegExp(r'\d+').firstMatch(v)?.group(0) ?? '');
        if (n == null || n <= 0) {
          return const Err(
            ValidationFailure('Escribe un precio mayor que cero.'),
          );
        }
        values[f.name] = '$n';
      } else if (v.isNotEmpty) {
        values[f.name] = v;
      }
    }
    if (await repo.byPostKey(postKeyOf(item)) != null) {
      return const Err(
        ValidationFailure('Ya enviaste una propuesta para esta publicación.'),
      );
    }
    final r = PostResponse(
      id: ids.newUuid(),
      postKey: postKeyOf(item),
      kind: kind,
      values: values,
      createdAt: clock.now(),
    );
    final saved = await repo.save(r);
    if (saved case Err(:final failure)) return Err(failure);
    return Ok(r);
  }
}
