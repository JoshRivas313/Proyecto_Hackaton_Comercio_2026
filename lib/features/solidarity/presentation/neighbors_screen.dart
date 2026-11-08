import 'package:flutter/material.dart';

import '../../needs/domain/need.dart';
import '../../needs/presentation/composer_sheet.dart';
import '../domain/wall_demo.dart';

/// Vecinos: muro de pedidos y ofertas sin dinero (economía solidaria). Contenido de ejemplo.
class NeighborsScreen extends StatefulWidget {
  const NeighborsScreen({super.key});

  @override
  State<NeighborsScreen> createState() => _NeighborsScreenState();
}

class _NeighborsScreenState extends State<NeighborsScreen> {
  bool _requests = true;
  String _mode = 'Todas';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final src = _requests ? demoWallRequests : demoWallOffers;
    final list = src.where((i) => _mode == 'Todas' || i.mode == _mode).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Entre vecinos')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Pide o ofrece ayuda sin necesidad de dinero. Lo que ves aquí es de ejemplo: '
            'todavía no hay cuentas para compartir entre vecinos.',
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => showComposer(context, kind: NeedKind.loan),
              icon: const Icon(Icons.swap_horiz),
              label: const Text('Pedir algo a un vecino'),
            ),
          ),
          const SizedBox(height: 16),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: true, label: Text('Pedidos')),
              ButtonSegment(value: false, label: Text('Ofertas')),
            ],
            selected: {_requests},
            onSelectionChanged: (s) => setState(() => _requests = s.first),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final m in ['Todas', ...wallModes])
                ChoiceChip(
                  label: Text(m),
                  selected: _mode == m,
                  onSelected: (_) => setState(() => _mode = m),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _requests ? 'Pedidos de tus vecinos' : 'Ofertas de tus vecinos',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          if (list.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(14),
                child: Text(
                  'No hay publicaciones con esta modalidad por ahora.',
                ),
              ),
            )
          else
            for (final i in list)
              Card(
                child: ListTile(
                  title: Text('${i.who}: ${i.text}'),
                  subtitle: Text('${i.distance} · ${i.mode}'),
                  trailing: const Chip(label: Text('Ejemplo')),
                ),
              ),
        ],
      ),
    );
  }
}
