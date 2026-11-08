import 'package:flutter/material.dart';

import 'explore_section.dart';

/// Mapa (pestaña central): Radar, Mapa y Lista comparten los mismos datos y filtros.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  ExploreView _view = ExploreView.map;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          16,
          MediaQuery.paddingOf(context).top + 12,
          16,
          100,
        ),
        children: [
          Text('Cerca de ti', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 10),
          SegmentedButton<ExploreView>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(
                value: ExploreView.map,
                label: Text('Mapa'),
                icon: Icon(Icons.map_outlined),
              ),
              ButtonSegment(
                value: ExploreView.radar,
                label: Text('Radar'),
                icon: Icon(Icons.radar),
              ),
              ButtonSegment(
                value: ExploreView.list,
                label: Text('Lista'),
                icon: Icon(Icons.view_list_outlined),
              ),
            ],
            selected: {_view},
            onSelectionChanged: (s) => setState(() => _view = s.first),
          ),
          const SizedBox(height: 14),
          ExploreSection(view: _view),
        ],
      ),
    );
  }
}
