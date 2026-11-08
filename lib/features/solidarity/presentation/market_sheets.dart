import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/example_badge.dart';
import '../../../core/geo/geo_math.dart';
import '../../../core/result.dart';
import '../domain/market.dart';

void _toast(BuildContext context, String msg) => ScaffoldMessenger.of(context)
    .showSnackBar(
      SnackBar(duration: const Duration(seconds: 6), content: Text(msg)),
    );

// ---------------------------------------------------------------- Vender un producto
Future<void> showSellSheet(BuildContext context) => showModalBottomSheet<void>(
  useRootNavigator: true,
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => const _SellSheet(),
);

class _SellSheet extends ConsumerStatefulWidget {
  const _SellSheet();

  @override
  ConsumerState<_SellSheet> createState() => _SellSheetState();
}

class _SellSheetState extends ConsumerState<_SellSheet> {
  final _text = TextEditingController();
  final _price = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _text.dispose();
    _price.dispose();
    super.dispose();
  }

  Future<void> _publish() async {
    final r = await ref.read(publishProductSaleProvider)(
      _text.text,
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
            duration: Duration(seconds: 6),
            content: Text(
              'Producto guardado. Mira las ofertas de ejemplo en Vecinos.',
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
          Text('Vender un producto', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 4),
          const Text(
            'Fijas el precio de lista; tus vecinos lo compran o proponen uno menor, y tú decides.',
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _text,
            minLines: 2,
            maxLines: 3,
            maxLength: 120,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Describe tu producto',
              hintText: 'Ej.: Bicicleta de paseo, aro 26',
            ),
            onChanged: (_) => setState(() => _error = null),
          ),
          TextField(
            controller: _price,
            keyboardType: TextInputType.number,
            maxLength: 5,
            decoration: InputDecoration(
              labelText: 'Precio de lista (S/)',
              errorText: _error,
              counterText: '',
            ),
            onChanged: (_) => setState(() => _error = null),
          ),
          Text(
            'Las fotos llegan en la próxima versión.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _publish,
              child: const Text('Publicar producto'),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------- Ofrecer algo al barrio
Future<void> showWallOfferSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const _WallOfferSheet(),
    );

class _WallOfferSheet extends ConsumerStatefulWidget {
  const _WallOfferSheet();

  @override
  ConsumerState<_WallOfferSheet> createState() => _WallOfferSheetState();
}

class _WallOfferSheetState extends ConsumerState<_WallOfferSheet> {
  final _text = TextEditingController();
  String? _mode;
  String? _error;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _publish() async {
    final r = await ref.read(publishWallOfferProvider)(_mode, _text.text);
    if (!mounted) {
      return;
    }
    switch (r) {
      case Ok():
        final messenger = ScaffoldMessenger.of(context);
        Navigator.of(context).pop();
        messenger.showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 6),
            content: Text('Oferta guardada. La verás en "Mis ofertas".'),
          ),
        );
      case Err(:final failure):
        setState(() => _error = failure.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
          Text('Ofrecer algo al barrio', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text('Modalidad', style: theme.textTheme.labelLarge),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final m in wallOfferModes)
                ChoiceChip(
                  label: Text(m),
                  selected: _mode == m,
                  onSelected: (_) => setState(() {
                    _mode = m;
                    _error = null;
                  }),
                ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _text,
            minLines: 2,
            maxLines: 3,
            maxLength: 120,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: '¿Qué ofreces?',
              hintText: 'Ej.: Presto una escalera los fines de semana',
              errorText: _error,
            ),
            onChanged: (_) => setState(() => _error = null),
          ),
          Text(
            'Se publica con tu zona aproximada, nunca tu dirección.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _publish,
              child: const Text('Publicar oferta'),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------- Mis productos y mis ofertas
class MyMarketSection extends ConsumerWidget {
  const MyMarketSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final sales = ref.watch(salesStreamProvider).value ?? const <ProductSale>[];
    final offers =
        ref.watch(wallOffersStreamProvider).value ?? const <WallOffer>[];
    if (sales.isEmpty && offers.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (offers.isNotEmpty) ...[
          Text('Mis ofertas', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          for (final o in offers)
            Card(
              child: ListTile(
                leading: const Icon(Icons.volunteer_activism_outlined),
                title: Text(o.text),
                subtitle: Text('${o.mode} · tu zona aproximada'),
                trailing: const Chip(label: Text('Publicada (demo)')),
              ),
            ),
          const SizedBox(height: 8),
        ],
        if (sales.isNotEmpty) ...[
          Text('Mis productos', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          for (final s in sales) _SaleCard(sale: s),
        ],
        const SizedBox(height: 8),
      ],
    );
  }
}

class _SaleCard extends ConsumerWidget {
  const _SaleCard({required this.sale});

  final ProductSale sale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final decide = ref.read(decideBuyerOfferProvider);
    final offers = buyerOffersFor(sale)
        .where((o) => !sale.rejected.contains(o.index))
        .toList();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(sale.text, style: theme.textTheme.titleMedium),
            Text(
              'Precio de lista S/ ${sale.priceSoles}',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            if (sale.sold)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.mint,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  'Vendido a S/ ${sale.soldPrice} · ${sale.soldTo} (ejemplo)',
                  style: const TextStyle(
                    color: Color(0xFF0B3D2E),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              )
            else if (offers.isEmpty)
              const Text('Sin ofertas por ahora.')
            else
              for (final o in offers)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${o.who} · ${formatDistance(o.distanceMeters)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const ExampleBadge(),
                          ],
                        ),
                        Text(
                          o.atListPrice
                              ? 'Compra al precio de lista'
                              : 'Propone S/ ${o.priceSoles} (lista S/ ${sale.priceSoles})',
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppTheme.coral,
                                  foregroundColor: const Color(0xFF2A1670),
                                ),
                                onPressed: () async {
                                  final r = await decide.accept(
                                    sale.id,
                                    o.index,
                                  );
                                  if (context.mounted && r is Err) {
                                    _toast(context, r.failure.message);
                                  }
                                },
                                child: Text('Aceptar S/ ${o.priceSoles}'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton(
                              onPressed: () => decide.reject(sale.id, o.index),
                              child: const Text('Rechazar'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
