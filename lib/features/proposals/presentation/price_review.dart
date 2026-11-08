import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/result.dart';
import '../domain/deal.dart';
import '../domain/price_change.dart';

/// «Revisar condiciones del servicio»: aparece SOLO después de validar el código de encuentro.
/// Muestra el precio vigente, las contraofertas disponibles (máx. 2 por trato) y el historial.
/// El prestador propone el nuevo monto; el cliente solo acepta o rechaza.
class PriceReviewSection extends ConsumerWidget {
  const PriceReviewSection({super.key, required this.deal});

  final Deal deal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final all =
        (ref.watch(priceChangesStreamProvider).value ?? const <PriceChange>[])
            .where((c) => c.dealId == deal.id)
            .toList();
    final pending = all
        .where((c) => c.status == PriceChangeStatus.pending)
        .firstOrNull;
    final left = maxCounterOffers - all.length;
    final negotiable = deal.priceSoles > 0;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.lilac,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Revisar condiciones del servicio',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppTheme.deepViolet,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Precio final vigente:  '),
              Text(
                deal.priceLabel,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.brand,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          if (!negotiable)
            Text(
              'Este trato no se negocia por precio.',
              style: theme.textTheme.bodySmall,
            )
          else ...[
            const SizedBox(height: 4),
            Text(
              pending != null
                  ? 'Hay una contraoferta pendiente.'
                  : left == 1
                  ? 'Última contraoferta disponible (1 de $maxCounterOffers).'
                  : left <= 0
                  ? 'Ya se usaron las $maxCounterOffers contraofertas de este trato.'
                  : 'Contraofertas disponibles: $left de $maxCounterOffers.',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            if (pending != null) ...[
              const SizedBox(height: 10),
              _PendingCard(change: pending, deal: deal),
            ] else if (left > 0)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'El prestador puede proponer un nuevo precio con su motivo. '
                  'El precio no cambia hasta que tú lo aceptes.',
                  style: theme.textTheme.bodySmall,
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Si no hay acuerdo, continúa con el precio vigente o cancela el trato.',
                  style: theme.textTheme.bodySmall,
                ),
              ),
          ],
          if (all.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              'Historial de contraofertas',
              style: theme.textTheme.titleSmall,
            ),
            for (final c in all)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'Prestador · S/ ${c.previousPrice} → S/ ${c.newPrice} · ${_status(c.status)}\n'
                  'Motivo: ${c.reason} · ${_date(c.createdAt)}',
                  style: theme.textTheme.bodySmall,
                ),
              ),
          ],
        ],
      ),
    );
  }

  static String _status(PriceChangeStatus s) => switch (s) {
    PriceChangeStatus.pending => 'pendiente',
    PriceChangeStatus.accepted => 'aceptada',
    PriceChangeStatus.rejected => 'rechazada',
  };

  static String _date(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')} '
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}

class _PendingCard extends ConsumerWidget {
  const _PendingCard({required this.change, required this.deal});

  final PriceChange change;
  final Deal deal;

  Future<void> _answer(BuildContext context, WidgetRef ref, bool accept) async {
    final r = await ref
        .read(counterOfferProvider)
        .respond(deal.id, change.id, accept: accept);
    if (!context.mounted) return;
    if (r case Err(:final failure)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(failure.message)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'El prestador propone S/ ${change.newPrice} (antes S/ ${change.previousPrice})',
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          Text('Motivo: ${change.reason}'),
          const SizedBox(height: 8),
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () => _answer(context, ref, true),
                  child: const Text('Aceptar'),
                ),
              ),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _answer(context, ref, false),
                  child: const Text('Rechazar'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Rechazar no tiene penalidad: el trato sigue con el precio vigente.',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

/// «Cancelar trato»: pide el motivo y lo registra. Sin multas ni baja de reputación.
Future<void> askCancelDeal(
  BuildContext context,
  WidgetRef ref,
  Deal deal,
) async {
  final reason = TextEditingController();
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Cancelar trato'),
      content: TextField(
        controller: reason,
        autofocus: true,
        maxLength: 120,
        decoration: const InputDecoration(
          labelText: 'Motivo de la cancelación',
          helperText: 'No hay multas ni se baja la reputación.',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Volver'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Cancelar trato'),
        ),
      ],
    ),
  );
  if (ok != true || !context.mounted) return;
  final r = await ref.read(cancelDealProvider)(deal.id, reason: reason.text);
  if (!context.mounted) return;
  if (r case Err(:final failure)) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(failure.message)));
  }
}
