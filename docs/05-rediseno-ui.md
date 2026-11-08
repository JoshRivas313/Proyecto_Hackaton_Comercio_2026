# Rediseño UI/UX (prompt 02) — auditoría, concepto y sistema de diseño

> Resumen de ejecución del prompt 02. Skills usados: `ui-ux-audit` (auditoría), `ui-ux-pro-max` (estilo, accesibilidad Flutter, estados), `mobile-design` (criterios de ergonomía, adaptados a Flutter). Estado previo recuperado: commit `62c52cf` (tema morado, Inicio con bienvenida y atajos, aviso de conexión, etiqueta "Ejemplo").

## 1. Auditoría (qué existe, qué falta, qué NO tocar)

| Pantalla | Existe | Hueco real | No tocar / no duplicar |
|---|---|---|---|
| Inicio | Bienvenida, atajos por oficio, ubicación, mis necesidades, Explorar | Sin ilustración ni identidad; CTA sin protagonismo; sin movimiento | La lógica de pedir (≤3 toques) y la tarjeta de ubicación |
| Servicios (Explorar) | Filtros, orden, tarjetas con Visto Bueno | Tarjetas "administrativas" repetidas; la distancia y la disponibilidad se pierden | Etiqueta "Ejemplo"; no inventar calificaciones ni "verificado" |
| Vecinos | Muro de ejemplo, filtros, botón pedir | Parece una lista; filtros sin identidad; estado vacío simple | Contenido de ejemplo rotulado |
| Emergencia | Instituciones primero, SOS, aviso de demo | Jerarquía en 3 niveles poco clara; sin consejos generales | Instituciones primero; violencia solo en el teléfono; aviso de que no se envían alertas reales |
| Perfil | Oficio, pedidos de ejemplo, tutorial, "sobre el prototipo" | Sin cabecera humana | Sin estadísticas ni reputación inventadas |

## 2. Dos conceptos

- **A. "Barrio cálido" (elegido):** crema cálida + violeta de identidad + coral de acción, ilustración de barrio (casas y vecinos de varias edades), formas redondeadas, microinteracciones suaves.
- **B. "Plaza vibrante":** fondo violeta oscuro inmersivo, acentos de alto contraste y formas geométricas.

**Decisión: A.** Es más legible para adultos mayores, mejor con luz exterior y transmite cercanía; B depende de modo oscuro y fatiga más al leer textos largos.

## 3. Sistema de diseño (contraste AA verificado)

| Rol | HEX | Uso | Texto sobre él |
|---|---|---|---|
| Violeta | `#5B3FC4` | Identidad, navegación, acciones secundarias | Blanco (7,1:1) |
| Violeta profundo | `#3B2790` | Cabeceras, ilustración | Blanco (11,2:1) |
| Lila | `#E9E3FF` | Superficies de énfasis | `#3B2790` |
| **Coral** | `#FF8A65` | **Acción principal ("Pedir algo")**, energía | `#2A1670` (6,3:1) |
| Sol | `#FFD166` | Destacados, ilustración | `#4A1F00` (9,8:1) |
| Menta | `#BDEFD3` | Disponibilidad, estados positivos | `#0B3D2E` (9,6:1) |
| Verde confirmado | `#0A6B66` | Solo "hecho / enviado / real" | Blanco |
| Cielo | `#CDE7FF` | Categorías de agua y servicios | `#12304D` (10,6:1) |
| Crema | `#FFF8F0` | Fondo de pantalla | `#1F1A33` (15,9:1) |
| Rojo emergencia | `#C42B1A` | Solo emergencia | Blanco (5,7:1) |

**Tipografía** (fuente del sistema, sin descargas para funcionar offline): encabezados 28/800, secciones 20/800, títulos de tarjeta 17/700, texto 16/400, secundario 14, etiquetas de botón 16/800.
**Movimiento:** entradas escalonadas de 300–450 ms, escala 0,96 al pulsar, vibración suave en acciones; todo se desactiva con "reducir animaciones".
**Ilustración:** `CustomPainter` propio (casas, vecinos, sol), sin imágenes de terceros y sin emojis.
