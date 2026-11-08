import 'package:flutter/material.dart';

import '../../../app/widgets/example_badge.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/geo/geo_math.dart';
import '../../../core/result.dart';
import '../../settings/presentation/tutorial_sheet.dart';
import '../domain/provider_side.dart';

/// Perfil: lo que hago (lado proveedor), pedidos cerca de mí, tutorial y qué es real en el prototipo.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

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
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          16,
          MediaQuery.paddingOf(context).top + 12,
          16,
          16,
        ),
        children: [
          // Cabecera humana: solo datos reales (cuántos oficios ofreces).
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppTheme.brand, AppTheme.deepViolet],
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 68,
                  height: 68,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppTheme.coral,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    'Tú',
                    style: TextStyle(
                      color: Color(0xFF2A1670),
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Vecino del barrio',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Tus datos se quedan en tu teléfono. Todavía no hay cuentas.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.3,
                        ),
                      ),
                      if (offers.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.lilac,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            offers.length == 1
                                ? '1 oficio que ofreces'
                                : '${offers.length} oficios que ofreces',
                            style: const TextStyle(
                              color: AppTheme.deepViolet,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('Lo que haces', style: theme.textTheme.titleLarge),
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
            const Text(
              'Mira el pedido, propón tu precio y el vecino elige. Los pedidos son de ejemplo.',
            ),
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
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () => showTutorial(context),
            icon: const Icon(Icons.help_outline),
            label: const Text('Ver tutorial'),
          ),
          const SizedBox(height: 20),
          Card(
            color: theme.colorScheme.secondaryContainer,
            child: const Padding(
              padding: EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sobre este prototipo',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Es de verdad: tu ubicación (GPS), el funcionamiento sin internet y el guardado en tu teléfono.',
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Es de ejemplo: los vecinos, negocios, precios y respuestas, y los números de emergencia, '
                    'que hay que verificar antes de usarlos.',
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Todavía no hay cuentas ni servidor: nada de lo que haces llega a otra persona.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> showOfferSheet(BuildContext context) => showModalBottomSheet<void>(
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
              ? 'Listo. Mira los pedidos de ejemplo en tu perfil.'
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
              helperText:
                  'Referencia del barrio (ejemplo): ${j.referencePrice}',
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
