import 'dart:io';

import 'package:flutter/material.dart';

import '../../../app/widgets/example_badge.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/di/providers.dart';
import '../../../core/geo/geo_math.dart';
import '../../../core/result.dart';
import '../../directory/domain/trades.dart';
import '../../explore/presentation/explore_controller.dart';
import '../../needs/domain/need.dart';
import '../../needs/presentation/need_labels.dart';
import '../../sync/presentation/sync_controller.dart';
import '../../../app/theme/app_theme.dart';
import '../domain/deal.dart';
import '../domain/negotiation.dart';
import '../domain/usecases/negotiate.dart';
import 'deal_panel.dart';
import 'deal_providers.dart';

enum _Sort { reputation, distance, price }

class NeedDetailScreen extends ConsumerStatefulWidget {
  const NeedDetailScreen({super.key, required this.needId});

  final String needId;

  @override
  ConsumerState<NeedDetailScreen> createState() => _NeedDetailScreenState();
}

class _NeedDetailScreenState extends ConsumerState<NeedDetailScreen> {
  _Sort _sort = _Sort.reputation;

  Future<void> _accept(ProposalView v) async {
    final need = ref.read(needByIdProvider(widget.needId));
    if (need == null) return;
    final r = await ref
        .read(negotiateProvider)
        .acceptOffer(need, v.proposal, by: OfferParty.client);
    _toastIfError(r);
  }

  void _toastIfError(Result<Object?> r) {
    if (!mounted) return;
    if (r case Err(:final failure)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(failure.message)));
    }
  }

  Future<void> _reject(ProposalView v) async {
    final need = ref.read(needByIdProvider(widget.needId));
    if (need == null) return;
    _toastIfError(
      await ref
          .read(negotiateProvider)
          .reject(need, v.proposal, by: OfferParty.client),
    );
  }

  Future<void> _counter(ProposalView v) async {
    final need = ref.read(needByIdProvider(widget.needId));
    if (need == null) return;
    final price = TextEditingController();
    final note = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Enviar contraoferta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Propuesta actual: ${v.proposal.priceLabel}'),
            const SizedBox(height: 8),
            TextField(
              controller: price,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Tu precio (S/)'),
            ),
            TextField(
              controller: note,
              maxLength: 120,
              decoration: const InputDecoration(
                labelText: 'Otras condiciones (opcional)',
                hintText: 'Ej.: puedo recibirte mañana a las 5 pm',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final digits = RegExp(r'\d+').firstMatch(price.text)?.group(0);
    _toastIfError(
      await ref
          .read(negotiateProvider)
          .counter(
            need,
            v.proposal,
            by: OfferParty.client,
            priceSoles: digits == null ? 0 : int.parse(digits),
            conditions: note.text,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final need = ref.watch(needByIdProvider(widget.needId));
    final deal = ref.watch(dealByNeedProvider(widget.needId));
    final isDemo = ref.watch(syncGatewayProvider).isDemo;

    if (need == null) {
      return Scaffold(
        appBar: AppBar(leading: BackButton(onPressed: () => context.go('/'))),
        body: const Center(child: Text('No encontramos este pedido.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go('/')),
        title: Text(NeedLabels.kind(need.kind)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(need.text, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text('Para: ${NeedLabels.urgency(need.urgency)}'),
          const SizedBox(height: 12),
          if (need.photoPath != null && File(need.photoPath!).existsSync())
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(need.photoPath!),
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          if (tradeById(need.categoryId) case final cat?)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: OutlinedButton.icon(
                onPressed: () {
                  ref
                      .read(exploreFiltersProvider.notifier)
                      .showTrade(cat.label);
                  context.go('/mapa');
                },
                icon: const Icon(Icons.near_me_outlined),
                label: Text('Ver ${cat.label.toLowerCase()} cerca de ti'),
              ),
            ),
          if (need.details != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(need.details!),
            ),
          _SyncCard(need: need, isDemo: isDemo),
          const SizedBox(height: 16),
          if (deal != null) ...[
            const _InDealBanner(),
            DealPanel(deal: deal),
            const SizedBox(height: 12),
            _NegotiationHistory(needId: widget.needId),
          ] else if (need.syncStatus == SyncStatus.sent)
            ..._proposals(context),
        ],
      ),
    );
  }

  List<Widget> _proposals(BuildContext context) {
    final theme = Theme.of(context);
    final views = ref.watch(proposalViewsProvider(widget.needId));
    return [
      Text('Propuestas de tu barrio', style: theme.textTheme.titleLarge),
      const SizedBox(height: 4),
      const Text(
        'Aquí el precio lo pone cada persona al ver tu pedido. Tú eliges.',
      ),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text('Ordenar por'),
          for (final s in _Sort.values)
            ChoiceChip(
              label: Text(switch (s) {
                _Sort.reputation => 'Reputación',
                _Sort.distance => 'Cercanía',
                _Sort.price => 'Precio',
              }),
              selected: _sort == s,
              onSelected: (_) => setState(() => _sort = s),
            ),
        ],
      ),
      const SizedBox(height: 8),
      views.when(
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (_, _) =>
            const Text('No pudimos cargar las propuestas. Inténtalo otra vez.'),
        data: (list) {
          if (list.isEmpty) {
            return const Card(
              child: Padding(
                padding: EdgeInsets.all(14),
                child: Text(
                  'Todavía no hay propuestas para este pedido. '
                  'En la versión con vecinos reales, aquí verás a quienes puedan ayudarte. '
                  'Prueba con un oficio como gasfitero, electricista, cerrajero, carpintero, costura, clases o mascotas.',
                ),
              ),
            );
          }
          final sorted = [...list]
            ..sort(
              (a, b) => switch (_sort) {
                _Sort.reputation => b.reputation.average.compareTo(
                  a.reputation.average,
                ),
                _Sort.distance => a.proposal.distanceMeters.compareTo(
                  b.proposal.distanceMeters,
                ),
                _Sort.price => a.proposal.priceSoles.compareTo(
                  b.proposal.priceSoles,
                ),
              },
            );
          final versions =
              (ref.watch(negotiationsStreamProvider).value ??
                      const <OfferVersion>[])
                  .where((o) => o.needId == widget.needId)
                  .toList();
          bool available(ProposalView v) {
            final last = lastOffer(versions, v.proposal.providerId)?.status;
            return last != OfferStatus.rejected &&
                last != OfferStatus.discarded;
          }

          final shown = sorted.where(available).toList();
          return Column(
            children: [
              for (final v in shown)
                _ProposalCard(
                  view: v,
                  current: currentOffer(versions, v.proposal.providerId),
                  negotiable: Negotiate.isPriceNegotiable(
                    ref.read(needByIdProvider(widget.needId))!,
                    v.proposal,
                  ),
                  onAccept: () => _accept(v),
                  onReject: () => _reject(v),
                  onCounter: () => _counter(v),
                ),
              if (shown.length < sorted.length)
                _NegotiationHistory(needId: widget.needId),
            ],
          );
        },
      ),
    ];
  }
}

class _SyncCard extends ConsumerWidget {
  const _SyncCard({required this.need, required this.isDemo});

  final Need need;
  final bool isDemo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busy = ref.watch(syncControllerProvider);
    final (icon, color) = switch (need.syncStatus) {
      SyncStatus.pending => (
        Icons.schedule,
        Theme.of(context).colorScheme.tertiaryContainer,
      ),
      SyncStatus.sent => (
        Icons.check_circle_outline,
        Theme.of(context).colorScheme.primaryContainer,
      ),
      SyncStatus.error => (
        Icons.error_outline,
        Theme.of(context).colorScheme.errorContainer,
      ),
    };
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(syncLabel(need.syncStatus, isDemo: isDemo)),
                ),
              ],
            ),
            if (need.syncStatus != SyncStatus.sent) ...[
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: busy
                    ? null
                    : () =>
                          ref.read(syncControllerProvider.notifier).flushNow(),
                child: Text(busy ? 'Enviando…' : 'Reintentar ahora'),
              ),
            ],
            if (need.syncStatus == SyncStatus.sent && isDemo)
              const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text('Las propuestas llegan de vecinos cercanos.'),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProposalCard extends StatelessWidget {
  const _ProposalCard({
    required this.view,
    required this.onAccept,
    required this.onReject,
    required this.onCounter,
    required this.negotiable,
    this.current,
  });

  final OfferVersion? current;
  final bool negotiable;
  final VoidCallback onReject;
  final VoidCallback onCounter;

  final ProposalView view;
  final VoidCallback onAccept;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = theme.colorScheme;
    final p = view.proposal;
    final rep = view.reputation;
    final initials = p.providerName
        .split(' ')
        .where((w) => w.isNotEmpty)
        .map((w) => w[0])
        .take(2)
        .join();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: s.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    initials,
                    style: TextStyle(
                      color: s.onPrimaryContainer,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.providerName, style: theme.textTheme.titleMedium),
                      Text(p.role, style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        p.priceLabel,
                        textAlign: TextAlign.end,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: s.primary,
                          // Un precio (S/ 40) va grande; un trato en texto (trueque) va más chico.
                          fontSize: p.priceLabel.startsWith('S/') ? 22 : 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (p.diagnosticVisitSoles != null)
                        Text(
                          'visita S/ ${p.diagnosticVisitSoles}',
                          style: theme.textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                _Mini(
                  icon: Icons.star_rounded,
                  text: rep.average.toStringAsFixed(1),
                ),
                _Mini(
                  icon: Icons.place_outlined,
                  text: 'a ${formatDistance(p.distanceMeters)} (aprox.)',
                ),
                _Mini(icon: Icons.schedule, text: p.availability),
                _Mini(
                  icon: Icons.verified_outlined,
                  text: '${view.vistoBueno.total} recomiendan',
                ),
                if (p.isExample) const ExampleBadge(),
              ],
            ),
            const SizedBox(height: 12),
            if (current != null)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: current!.by == OfferParty.client
                      ? AppTheme.coralSoft
                      : AppTheme.lilac,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  current!.by == OfferParty.client
                      ? 'Contraoferta enviada: ${current!.priceLabel}'
                            '${current!.conditions == null ? '' : ' · ${current!.conditions}'}\n'
                            'Esperando la respuesta del prestador.'
                      : 'Contraoferta del prestador: ${current!.priceLabel}'
                            '${current!.conditions == null ? '' : ' · ${current!.conditions}'}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            if (current == null || current!.by == OfferParty.provider) ...[
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onAccept,
                  child: Text(
                    current == null
                        ? 'Aceptar propuesta'
                        : 'Aceptar ${current!.priceLabel}',
                  ),
                ),
              ),
              Row(
                children: [
                  if (negotiable)
                    Expanded(
                      child: TextButton.icon(
                        onPressed: onCounter,
                        icon: const Icon(Icons.swap_horiz),
                        label: const Text('Contraoferta'),
                      ),
                    ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: onReject,
                      icon: const Icon(Icons.close),
                      label: const Text('Rechazar'),
                    ),
                  ),
                ],
              ),
            ] else
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: onReject,
                  child: const Text('Retirar mi oferta'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Mini extends StatelessWidget {
  const _Mini({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: s.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: s.primary),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: s.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

/// Texto del estado del trato (también lo usa la lista de Inicio en el futuro).
String dealStatusLabel(DealStatus s) => switch (s) {
  DealStatus.accepted => 'Aceptada',
  DealStatus.inProgress => 'En curso',
  DealStatus.awaitingRating => 'Falta calificar',
  DealStatus.closed => 'Resuelta',
};

/// Aviso de que el pedido ya tiene una propuesta aceptada: no admite otras.
class _InDealBanner extends StatelessWidget {
  const _InDealBanner();

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppTheme.greenSoft,
      borderRadius: BorderRadius.circular(14),
    ),
    child: const Row(
      children: [
        Icon(Icons.handshake_rounded, color: AppTheme.confirmed),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            'En trato. Este pedido ya fue asignado y no recibe más propuestas.',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppTheme.onMint,
            ),
          ),
        ),
      ],
    ),
  );
}

/// Historial de la negociación: acuerdos, contraofertas, rechazos y propuestas descartadas.
class _NegotiationHistory extends ConsumerWidget {
  const _NegotiationHistory({required this.needId});

  final String needId;

  static String _label(OfferVersion v) {
    final who = v.by == OfferParty.client ? 'Tú' : 'Prestador';
    return switch (v.status) {
      OfferStatus.accepted => 'Acuerdo aceptado · ${v.priceLabel}',
      OfferStatus.rejected => 'Rechazada · ${v.priceLabel}',
      OfferStatus.discarded => 'Descartada (pedido asignado) · ${v.priceLabel}',
      OfferStatus.countered => '$who ofreció ${v.priceLabel} · respondida',
      OfferStatus.pending => '$who ofreció ${v.priceLabel} · vigente',
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final versions =
        (ref.watch(negotiationsStreamProvider).value ?? const <OfferVersion>[])
            .where((v) => v.needId == needId)
            .toList();
    if (versions.isEmpty) return const SizedBox.shrink();
    return Theme(
      data: theme.copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: Text(
          'Historial de propuestas',
          style: theme.textTheme.titleMedium,
        ),
        children: [
          for (final v in versions)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                switch (v.status) {
                  OfferStatus.accepted => Icons.check_circle,
                  OfferStatus.rejected => Icons.cancel_outlined,
                  OfferStatus.discarded => Icons.block,
                  _ => Icons.swap_horiz,
                },
                color: v.status == OfferStatus.accepted
                    ? AppTheme.confirmed
                    : theme.colorScheme.onSurfaceVariant,
              ),
              title: Text(_label(v)),
              subtitle: v.conditions == null ? null : Text(v.conditions!),
            ),
        ],
      ),
    );
  }
}
