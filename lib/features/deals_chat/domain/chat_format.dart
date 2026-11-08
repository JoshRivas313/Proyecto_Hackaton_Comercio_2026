import 'chat.dart';

const _dias = [
  'lunes',
  'martes',
  'miércoles',
  'jueves',
  'viernes',
  'sábado',
  'domingo',
];
const _meses = [
  'enero',
  'febrero',
  'marzo',
  'abril',
  'mayo',
  'junio',
  'julio',
  'agosto',
  'septiembre',
  'octubre',
  'noviembre',
  'diciembre',
];

String _two(int n) => n.toString().padLeft(2, '0');

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

/// `HH:mm` de un mensaje.
String hhmm(DateTime t) => '${_two(t.hour)}:${_two(t.minute)}';

/// Hora para la bandeja: hoy `HH:mm`, ayer «Ayer», esta semana el día, antes la fecha.
String listTime(DateTime t, DateTime now) {
  final diff = _day(now).difference(_day(t)).inDays;
  if (diff <= 0) return hhmm(t);
  if (diff == 1) return 'Ayer';
  if (diff < 7) return _dias[t.weekday - 1];
  return '${_two(t.day)}/${_two(t.month)}/${t.year}';
}

/// Separador de fecha dentro de la conversación.
String dayLabel(DateTime t, DateTime now) {
  final diff = _day(now).difference(_day(t)).inDays;
  if (diff <= 0) return 'Hoy';
  if (diff == 1) return 'Ayer';
  if (diff < 7) return _dias[t.weekday - 1];
  return '${t.day} de ${_meses[t.month - 1]} de ${t.year}';
}

bool sameDay(DateTime a, DateTime b) => _day(a) == _day(b);

/// Mensajes del otro vecino posteriores a la última vez que abriste la conversación.
int unreadCount(List<ChatMessage> messages, DateTime? readAt) => messages
    .where((m) => !m.fromMe && (readAt == null || m.createdAt.isAfter(readAt)))
    .length;

/// «Sin responder»: el último mensaje lo envió el otro vecino (no depende de si lo leíste).
bool awaitingMyReply(List<ChatMessage> messages) =>
    messages.isNotEmpty && !messages.last.fromMe;
