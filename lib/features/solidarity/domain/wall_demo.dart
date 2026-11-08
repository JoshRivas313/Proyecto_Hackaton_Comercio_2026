/// Modalidades del muro (paridad con `MODS` del PWA).
const wallModes = [
  'Préstamo',
  'Trueque',
  'Alquiler',
  'Donación',
  'Favor',
  'Intercambio de habilidades',
  'Movilidad solidaria',
];

class WallItem {
  const WallItem(this.who, this.text, this.distance, this.mode);
  final String who;
  final String text;
  final String distance;
  final String mode;
}

/// Contenido de DEMOSTRACIÓN del muro (no son personas reales). Del PWA: `REQS` y `OFRS`.
const demoWallRequests = [
  WallItem(
    'Ana Salas',
    'Necesita una escalera por la tarde',
    '200 m',
    'Préstamo',
  ),
  WallItem(
    'Don Teodoro',
    'Busca compañía para ir a la posta',
    '450 m',
    'Movilidad solidaria',
  ),
  WallItem(
    'Lucía Prado',
    'Busca ayuda con inglés a cambio de clases de matemática',
    '520 m',
    'Intercambio de habilidades',
  ),
  WallItem(
    'Ana Salas',
    'Necesita ayuda para cargar las compras',
    '200 m',
    'Favor',
  ),
  WallItem('Hugo Cáceres', 'Pide ayuda para mover un mueble', '380 m', 'Favor'),
];

const demoWallOffers = [
  WallItem(
    'Mario Soto',
    'Presta un taladro y herramientas',
    '300 m',
    'Préstamo',
  ),
  WallItem(
    'Teresa Gil',
    'Regala ropa de bebé en buen estado',
    '520 m',
    'Donación',
  ),
  WallItem(
    'Mateo Quispe',
    'Enseña Lengua de Señas Peruana a cambio de ayuda con trámites',
    '610 m',
    'Intercambio de habilidades',
  ),
  WallItem(
    'Pablo Reyes',
    'Lleva a vecinos al mercado los sábados',
    '440 m',
    'Movilidad solidaria',
  ),
  WallItem(
    'Sara León',
    'Ayuda con tareas del colegio (primaria)',
    '700 m',
    'Favor',
  ),
];
