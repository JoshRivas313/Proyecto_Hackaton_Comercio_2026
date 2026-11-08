import '../../../core/result.dart';
import '../../needs/domain/need.dart';

/// Tipos de situación (paridad con `ETYPES` del PWA).
enum EmergencyType {
  quake(
    label: 'Sismo o desastre',
    institution: 'Defensa Civil (INDECI)',
    phone: '115',
    needs: [
      'Agua',
      'Refugio temporal',
      'Herramientas',
      'Alimentos',
      'Primeros auxilios',
    ],
    template: 'Hubo un sismo y necesito ayuda.',
  ),
  fire(
    label: 'Incendio',
    institution: 'Bomberos',
    phone: '116',
    needs: ['Agua', 'Refugio temporal', 'Ropa y frazadas', 'Movilidad'],
    template: 'Hay un incendio en mi vivienda o cerca.',
  ),
  medical(
    label: 'Emergencia médica',
    institution: 'SAMU',
    phone: '106',
    needs: ['Primeros auxilios', 'Movilidad al centro de salud', 'Compañía'],
    template: 'Una persona necesita atención médica.',
  ),
  elder(
    label: 'Persona mayor o sola',
    institution: 'Serenazgo o centro de salud de tu municipalidad',
    phone: null,
    needs: ['Compañía', 'Movilidad', 'Alimentos'],
    template: 'Una persona mayor necesita compañía o ayuda.',
  ),
  violence(
    label: 'Violencia o acoso',
    institution: 'Línea 100 y Policía',
    phone: '100',
    needs: ['Espacio seguro', 'Acompañamiento'],
    template: 'Necesito ayuda.',
    isPrivate: true,
  );

  const EmergencyType({
    required this.label,
    required this.institution,
    required this.phone,
    required this.needs,
    required this.template,
    this.isPrivate = false,
  });

  final String label;

  /// Institución oficial a la que se llama PRIMERO (regla inviolable 5).
  final String institution;

  /// Número a marcar. `null` cuando depende de la municipalidad.
  final String? phone;
  final List<String> needs;

  /// Texto inicial de "qué pasó": editar es opcional (menos toques y menos escritura).
  final String template;

  /// Caso sensible: nunca sale a un muro y esta versión no avisa a nadie.
  final bool isPrivate;
}

/// Contactos oficiales. TODOS los números están POR VERIFICAR con fuentes oficiales antes de la demo.
class OfficialContact {
  const OfficialContact(this.name, this.phone, this.detail);
  final String name;
  final String phone;
  final String detail;
}

const officialContacts = <OfficialContact>[
  OfficialContact(
    'Policía Nacional',
    '105',
    'Robo, agresión, personas desaparecidas',
  ),
  OfficialContact('Bomberos', '116', 'Incendio y rescate'),
  OfficialContact('SAMU', '106', 'Emergencia médica'),
  OfficialContact(
    'Defensa Civil (INDECI)',
    '115',
    'Sismo, inundación y huaico',
  ),
  OfficialContact(
    'Línea 100',
    '100',
    'Violencia familiar y sexual: consulta y apoyo',
  ),
];

class EmergencyPost {
  const EmergencyPost({
    required this.id,
    required this.type,
    required this.why,
    required this.needs,
    required this.createdAt,
    required this.syncStatus,
  });

  final String id;
  final EmergencyType type;
  final String why;
  final List<String> needs;
  final DateTime createdAt;
  final SyncStatus syncStatus;

  bool get isPrivate => type.isPrivate;
}

abstract interface class EmergencyRepository {
  Future<Result<void>> save(EmergencyPost post);

  Future<Result<void>> updateStatus(String id, SyncStatus status);

  Stream<List<EmergencyPost>> watchAll();
}
