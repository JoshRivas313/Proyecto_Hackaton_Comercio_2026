import 'package:flutter/material.dart';

import '../../../app/widgets/example_badge.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/geo/geo_math.dart';
import '../../../core/result.dart';
import '../../settings/presentation/tutorial_sheet.dart';
import '../../needs/domain/need.dart';
import '../../proposals/domain/deal.dart';
import '../domain/provider_side.dart';

/// Perfil: avatar, estado, tres números PROPIOS y reales, y filas de capacidades y actividad.
/// No hay foto, "verificado" ni reputación inventada: solo lo que de verdad existe en este teléfono.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final offers =
        ref.watch(offersStreamProvider).value ?? const <ServiceOffer>[];
    final needs = ref.watch(needsStreamProvider).value ?? const <Need>[];
    final deals = ref.watch(dealsStreamProvider).value ?? const [];
    final proposals =
        ref.watch(jobProposalsStreamProvider).value ?? const <JobProposal>[];
    final resolved = deals.where((d) => d.status == DealStatus.closed).length;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          16,
          MediaQuery.paddingOf(context).top + 8,
          16,
          96,
        ),
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              tooltip: 'Ajustes y ayuda',
              iconSize: 28,
              onPressed: () => _showAbout(context),
              icon: const Icon(Icons.settings_outlined),
            ),
          ),
          Center(
            child: Container(
              width: 104,
              height: 104,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.brand, width: 3),
              ),
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppTheme.coral,
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  'Tú',
                  style: TextStyle(
                    color: Color(0xFF2A1670),
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'Vecino del barrio',
              style: theme.textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.coralSoft,
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info_outline, size: 18, color: Color(0xFF4A1F00)),
                  SizedBox(width: 6),
                  Text(
                    'Perfil sin verificar',
                    style: TextStyle(
                      color: Color(0xFF4A1F00),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              'Tus datos se quedan en tu teléfono. Todavía no hay cuentas.',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _Stat(
                value: '${needs.length}',
                label: 'Pedidos',
                bg: AppTheme.sun,
                fg: const Color(0xFF4A1F00),
              ),
              const SizedBox(width: 10),
              _Stat(
                value: '$resolved',
                label: 'Tratos resueltos',
                bg: AppTheme.sky,
                fg: const Color(0xFF12304D),
              ),
              const SizedBox(width: 10),
              _Stat(
                value: '${proposals.length}',
                label: 'Propuestas',
                bg: const Color(0xFFE9E3FF),
                fg: AppTheme.deepViolet,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _Row(
            icon: Icons.handyman_outlined,
            title: 'Mis capacidades',
            subtitle: offers.isEmpty
                ? 'Cuéntanos qué haces'
                : offers.map((o) => o.trade).join(', '),
            onTap: () => _showCapabilities(context),
          ),
          _Row(
            icon: Icons.history_rounded,
            title: 'Mi actividad',
            subtitle: 'Pedidos, tratos y calificaciones',
            onTap: () => _showActivity(context),
          ),
          _Row(
            icon: Icons.help_outline,
            title: 'Tutorial',
            subtitle: 'Aprende a usar la app en 4 pasos',
            onTap: () => showTutorial(context),
          ),
          _Row(
            icon: Icons.science_outlined,
            title: 'Sobre este prototipo',
            subtitle: 'Qué es real y qué es de ejemplo',
            onTap: () => _showAbout(context),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.value,
    required this.label,
    required this.bg,
    required this.fg,
  });

  final String value;
  final String label;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Semantics(
      label: '$value $label',
      child: ExcludeSemantics(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Text(
                value,
                style: TextStyle(
                  color: fg,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: fg,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _Row extends StatelessWidget {
  const _Row({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, size: 34, color: theme.colorScheme.primary),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleMedium),
                    Text(subtitle, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _showAbout(BuildContext context) => showModalBottomSheet<void>(
  useRootNavigator: true,
  context: context,
  showDragHandle: true,
  builder: (_) => const Padding(
    padding: EdgeInsets.fromLTRB(20, 0, 20, 24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sobre este prototipo',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
        SizedBox(height: 10),
        Text(
          'Es de verdad: tu ubicación (GPS), el funcionamiento sin internet y el guardado en tu teléfono.',
        ),
        SizedBox(height: 8),
        Text(
          'Es de ejemplo: los vecinos, negocios, precios y respuestas, y los números de emergencia, '
          'que hay que verificar antes de usarlos.',
        ),
        SizedBox(height: 8),
        Text(
          'Todavía no hay cuentas ni servidor: nada de lo que haces llega a otra persona.',
        ),
      ],
    ),
  ),
);

Future<void> _showActivity(BuildContext context) => showModalBottomSheet<void>(
  useRootNavigator: true,
  context: context,
  showDragHandle: true,
  builder: (_) => const _ActivitySheet(),
);

class _ActivitySheet extends ConsumerWidget {
  const _ActivitySheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final needs = ref.watch(needsStreamProvider).value ?? const <Need>[];
    final deals = ref.watch(dealsStreamProvider).value ?? const [];
    final given = ref.watch(interactionsStreamProvider).value?.length ?? 0;
    final proposals = ref.watch(jobProposalsStreamProvider).value?.length ?? 0;
    final resolved = deals.where((d) => d.status == DealStatus.closed).length;
    Widget line(String a, int n) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(a),
          Text(
            '$n',
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
        ],
      ),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mi actividad',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          line('Pedidos publicados', needs.length),
          line('Tratos resueltos', resolved),
          line('Calificaciones que diste', given),
          line('Propuestas de precio enviadas', proposals),
          const SizedBox(height: 8),
          Text(
            'Solo tú ves este resumen. No hay puntos ni puestos públicos.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

Future<void> _showCapabilities(BuildContext context) =>
    showModalBottomSheet<void>(
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const _CapabilitiesSheet(),
    );

class _CapabilitiesSheet extends ConsumerWidget {
  const _CapabilitiesSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final offers =
        ref.watch(offersStreamProvider).value ?? const <ServiceOffer>[];
    final jobs = ref.watch(jobRequestsProvider).value ?? const <JobRequest>[];
    final sent = {
      for (final p
          in ref.watch(jobProposalsStreamProvider).value ??
              const <JobProposal>[])
        p.jobId: p,
    };
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.85,
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        shrinkWrap: true,
        children: [
          Text('Mis capacidades', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 4),
          const Text(
            'Cuéntanos qué haces y cuándo puedes. No pones precio ahora: lo propones cuando veas un pedido.',
          ),
          const SizedBox(height: 8),
          for (final o in offers)
            Card(
              child: ListTile(
                leading: const Icon(Icons.handyman_outlined),
                title: Text(o.trade),
                subtitle: Text('Disponible: ${o.availability}'),
                trailing: const Chip(label: Text('Activo')),
              ),
            ),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => showOfferSheet(context),
              icon: const Icon(Icons.add),
              label: Text(
                offers.isEmpty ? 'Agregar lo que hago' : 'Agregar otro oficio',
              ),
            ),
          ),
          if (offers.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text('Pedidos cerca de ti', style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            const Text('Mira el pedido, propón tu precio y el vecino elige.'),
            const SizedBox(height: 8),
            for (final j in jobs)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              j.who,
                              style: theme.textTheme.titleMedium,
                            ),
                          ),
                          const ExampleBadge(),
                        ],
                      ),
                      Text(j.text),
                      Text(
                        'A ~${formatDistance(j.distanceMeters)} (aprox.) · Lo necesita: ${j.when}',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      if (sent[j.id] case final p?)
                        Text(
                          'Propuesta enviada: S/ ${p.priceSoles}. Esperando respuesta (en esta demo nadie responde de verdad).',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        )
                      else
                        FilledButton.tonal(
                          onPressed: () => showJobSheet(context, j),
                          child: const Text('Ver pedido y proponer mi precio'),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

Future<void> showOfferSheet(BuildContext context) => showModalBottomSheet<void>(
  useRootNavigator: true,
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => const _OfferSheet(),
);

class _OfferSheet extends ConsumerStatefulWidget {
  const _OfferSheet();

  @override
  ConsumerState<_OfferSheet> createState() => _OfferSheetState();
}

class _OfferSheetState extends ConsumerState<_OfferSheet> {
  String? _trade;
  String _availability = offerAvailabilities.first;

  Future<void> _save() async {
    final r = await ref.read(publishServiceOfferProvider)(
      trade: _trade ?? '',
      availability: _availability,
    );
    if (!mounted) {
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 6),
        content: Text(
          r.isOk
              ? 'Listo. Mira los pedidos en tu perfil.'
              : (r as Err).failure.message,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cuéntanos qué haces', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text('¿Qué haces?', style: theme.textTheme.labelLarge),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final t in offerTrades)
                ChoiceChip(
                  label: Text(t),
                  selected: _trade == t,
                  onSelected: (_) => setState(() => _trade = t),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text('¿Cuándo puedes?', style: theme.textTheme.labelLarge),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: [
              for (final a in offerAvailabilities)
                ChoiceChip(
                  label: Text(a),
                  selected: _availability == a,
                  onSelected: (_) => setState(() => _availability = a),
                ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'No pones precio ahora. Cuando alguien cerca necesite lo que haces, verás su pedido y propones tu precio.',
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _trade == null ? null : _save,
              child: const Text('Guardar lo que hago'),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> showJobSheet(BuildContext context, JobRequest job) =>
    showModalBottomSheet<void>(
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _JobSheet(job: job),
    );

class _JobSheet extends ConsumerStatefulWidget {
  const _JobSheet({required this.job});

  final JobRequest job;

  @override
  ConsumerState<_JobSheet> createState() => _JobSheetState();
}

class _JobSheetState extends ConsumerState<_JobSheet> {
  final _price = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _price.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final r = await ref.read(sendJobProposalProvider)(
      widget.job.id,
      _price.text,
    );
    if (!mounted) {
      return;
    }
    switch (r) {
      case Ok():
        final messenger = ScaffoldMessenger.of(context);
        Navigator.of(context).pop();
        messenger.showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 7),
            content: Text(
              'Propuesta guardada. Esta versión no tiene vecinos reales: nadie la responderá.',
            ),
          ),
        );
      case Err(:final failure):
        setState(() => _error = failure.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final j = widget.job;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        0,
        16,
        16 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pedido de ${j.who.split(' ').first}',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(j.text, style: theme.textTheme.titleMedium),
          Text(
            'A ~${formatDistance(j.distanceMeters)} (distancia aproximada; la dirección exacta solo se ve si te aceptan)',
            style: theme.textTheme.bodySmall,
          ),
          Text('Lo necesita: ${j.when}', style: theme.textTheme.bodySmall),
          const SizedBox(height: 12),
          TextField(
            controller: _price,
            keyboardType: TextInputType.number,
            maxLength: 5,
            decoration: InputDecoration(
              labelText: 'Tu precio (S/): lo propones tú',
              helperText: 'Referencia del barrio: ${j.referencePrice}',
              border: const OutlineInputBorder(),
              errorText: _error,
            ),
            onChanged: (_) => setState(() => _error = null),
          ),
          const Text(
            'Es un precio estimado. Si al ver el problema es otro, podrás proponer un ajuste; solo cambia si el cliente acepta.',
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _send,
              child: const Text('Enviar propuesta'),
            ),
          ),
        ],
      ),
    );
  }
}
