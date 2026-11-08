import 'package:flutter/material.dart';

import '../../../app/widgets/example_badge.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/geo/geo_math.dart';
import '../../../core/result.dart';
import '../../location/presentation/location_controller.dart';
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
    final loc = ref.watch(locationControllerProvider);
    final interactions =
        ref.watch(interactionsStreamProvider).value ?? const [];
    final recommended = interactions.where((i) => i.recommended).length;
    final recent = needs.reversed.take(3).toList();

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.only(bottom: 96),
        children: [
          // Cabecera violeta con personalidad: avatar, alias y zona aproximada.
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                  20,
                  MediaQuery.paddingOf(context).top + 20,
                  20,
                  56,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppTheme.brand, AppTheme.brandLight],
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(32),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 84,
                      height: 84,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppTheme.coral,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: const Text(
                        'Tú',
                        style: TextStyle(
                          color: AppTheme.onCoral,
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Vecino del barrio',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          if (loc.location != null)
                            const Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.place_outlined,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Zona aproximada · sin dirección exacta',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 6),
                          Text(
                            'Perfil sin verificar · tus datos están en tu teléfono',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Resumen compacto con cifras reales, montado sobre la cabecera.
              Positioned(
                left: 16,
                right: 16,
                bottom: -34,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: AppTheme.shadowInk,
                        blurRadius: 16,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      _StatCell(value: '${needs.length}', label: 'Pedidos'),
                      const _StatDivider(),
                      _StatCell(value: '$resolved', label: 'Tratos resueltos'),
                      const _StatDivider(),
                      _StatCell(
                        value: '${proposals.length}',
                        label: 'Propuestas',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Capacidades registradas, directamente como chips.
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Lo que sé hacer',
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _showCapabilities(context),
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: const Text('Editar'),
                    ),
                  ],
                ),
                if (offers.isEmpty)
                  OutlinedButton.icon(
                    onPressed: () => _showCapabilities(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Cuéntanos qué haces'),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final o in offers)
                        Chip(
                          avatar: const Icon(Icons.handyman_outlined, size: 18),
                          label: Text(o.trade),
                          backgroundColor: AppTheme.lilac,
                          side: BorderSide.none,
                        ),
                    ],
                  ),
                const SizedBox(height: 22),
                _VistoBuenoCard(recommended: recommended),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Mi actividad',
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    TextButton(
                      onPressed: () => _showActivity(context),
                      child: const Text('Ver todo'),
                    ),
                  ],
                ),
                if (recent.isEmpty)
                  Text(
                    'Cuando pidas algo, aparecerá aquí.',
                    style: theme.textTheme.bodyMedium,
                  )
                else
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        for (final (i, n) in recent.indexed) ...[
                          if (i > 0)
                            Divider(
                              height: 1,
                              indent: 56,
                              color: theme.colorScheme.outlineVariant,
                            ),
                          ListTile(
                            leading: const Icon(
                              Icons.campaign_outlined,
                              color: AppTheme.brand,
                            ),
                            title: Text(
                              n.text,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: const Text('Pedido publicado'),
                          ),
                        ],
                      ],
                    ),
                  ),
                const SizedBox(height: 18),
                _Row(
                  icon: Icons.help_outline,
                  title: 'Ayuda y tutorial',
                  subtitle: 'Aprende a usar la app en 4 pasos',
                  onTap: () => showTutorial(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Semantics(
      label: '$value $label',
      child: ExcludeSemantics(
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: AppTheme.brand,
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    ),
  );
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) => Container(
    width: 1,
    height: 36,
    color: Theme.of(context).colorScheme.outlineVariant,
  );
}

/// «Visto Bueno Vecinal»: identidad gráfica propia. Solo cuenta recomendaciones reales
/// (las que diste tras un trato cerrado); las que recibas aparecerán cuando haya cuentas.
class _VistoBuenoCard extends StatelessWidget {
  const _VistoBuenoCard({required this.recommended});

  final int recommended;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.greenSoft,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.confirmed.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppTheme.confirmed,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Visto Bueno Vecinal',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.onMint,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  recommended == 0
                      ? 'Cada recomendación cuenta solo después de un trato cerrado.'
                      : 'Recomendaste a $recommended ${recommended == 1 ? 'vecino' : 'vecinos'} tras un trato cerrado.',
                  style: const TextStyle(color: AppTheme.onMint),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
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
                          'Propuesta enviada: S/ ${p.priceSoles}. Esperando respuesta (aún no hay vecinos conectados que respondan).',
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
