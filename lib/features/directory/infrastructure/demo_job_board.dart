import '../domain/provider_side.dart';

/// Pedidos de DEMOSTRACIÓN para quien ofrece un oficio (vienen del PWA: `JOBTXT`, `JOBPEOPLE`, `REFP`).
class DemoJobBoard implements JobBoard {
  const DemoJobBoard();

  static const _texts = <String, List<String>>{
    'Gasfitería': [
      'Necesito arreglar una fuga en el lavadero',
      'Se malogró la llave del baño',
    ],
    'Electricidad': [
      'Se fue la luz en la cocina',
      'Necesito cambiar un tomacorriente',
    ],
    'Costura': ['Necesito arreglar un pantalón', 'Necesito ajustar un vestido'],
    'Clases particulares': [
      'Busco clases de matemática para mi hijo',
      'Necesito reforzar inglés',
    ],
    'Cuidado de niños': [
      'Necesito cuidado para mi hijo 2 horas',
      'Busco alguien para el sábado en la tarde',
    ],
    'Otro': [
      'Necesito ayuda con una tarea del hogar',
      'Necesito una mano con un arreglo',
    ],
  };
  static const _ref = <String, String>{
    'Gasfitería': 'S/ 30–45',
    'Electricidad': 'S/ 35–50',
    'Costura': 'S/ 10–20',
    'Clases particulares': 'S/ 20–30',
    'Cuidado de niños': 'S/ 15–25',
    'Otro': 'S/ 20–40',
  };
  static const _people = [
    ('Marta Díaz', 400.0, 'Hoy'),
    ('Raúl Ortiz', 650.0, 'Esta semana'),
  ];

  @override
  Future<List<JobRequest>> requestsFor(String trade) async {
    final texts = _texts[trade] ?? _texts['Otro']!;
    return [
      for (var i = 0; i < _people.length; i++)
        JobRequest(
          id: 'job-$trade-$i',
          trade: trade,
          who: _people[i].$1,
          text: texts[i],
          distanceMeters: _people[i].$2,
          when: _people[i].$3,
          referencePrice: _ref[trade] ?? _ref['Otro']!,
        ),
    ];
  }
}
