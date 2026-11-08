import 'package:flutter_test/flutter_test.dart';
import 'package:red_barrio/features/deals_chat/domain/chat.dart';
import 'package:red_barrio/features/deals_chat/domain/chat_format.dart';

ChatMessage _m(String id, bool me, DateTime at) =>
    ChatMessage(id: id, dealId: 'd', fromMe: me, text: id, createdAt: at);

void main() {
  final now = DateTime(2026, 11, 8, 15, 30);

  test('hora de la bandeja: hoy HH:mm, ayer, día de la semana y fecha', () {
    expect(listTime(DateTime(2026, 11, 8, 9, 5), now), '09:05');
    expect(listTime(DateTime(2026, 11, 7, 23, 59), now), 'Ayer');
    expect(listTime(DateTime(2026, 11, 4, 10), now), 'miércoles');
    expect(listTime(DateTime(2026, 10, 1, 10), now), '01/10/2026');
  });

  test('separador de fecha dentro del chat', () {
    expect(dayLabel(DateTime(2026, 11, 8, 1), now), 'Hoy');
    expect(dayLabel(DateTime(2026, 11, 7, 1), now), 'Ayer');
    expect(dayLabel(DateTime(2026, 9, 3, 1), now), '3 de septiembre de 2026');
  });

  test(
    'sin leer cuenta solo mensajes del otro vecino posteriores a la lectura',
    () {
      final msgs = [
        _m('a', false, DateTime(2026, 11, 8, 10)),
        _m('b', true, DateTime(2026, 11, 8, 11)),
        _m('c', false, DateTime(2026, 11, 8, 12)),
      ];
      expect(unreadCount(msgs, null), 2);
      expect(unreadCount(msgs, DateTime(2026, 11, 8, 10, 30)), 1);
      expect(unreadCount(msgs, DateTime(2026, 11, 8, 13)), 0);
    },
  );

  test('sin responder depende del último mensaje, no de si lo leíste', () {
    final t = DateTime(2026, 11, 8);
    expect(awaitingMyReply([]), isFalse);
    expect(awaitingMyReply([_m('a', false, t)]), isTrue);
    expect(awaitingMyReply([_m('a', false, t), _m('b', true, t)]), isFalse);
  });
}
