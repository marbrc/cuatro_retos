import 'package:flutter/material.dart';

import '../models/coin.dart';
import '../services/crypto_service.dart';
import '../theme/app_theme.dart';
import '../utils/convertidor.dart';
import '../widgets/common.dart';

class CryptoScreen extends StatefulWidget {
  const CryptoScreen({super.key});

  @override
  State<CryptoScreen> createState() => _CryptoScreenState();
}

class _CryptoScreenState extends State<CryptoScreen> {
  final _service = CryptoService();
  final _amountCtrl = TextEditingController(text: '100');
  late Future<List<Coin>> _future;
  double _usd = 100;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchPrices();
  }

  void _refresh() => setState(() => _future = _service.fetchPrices());

  void _onAmountChanged(String value) {
    setState(() => _usd = Convertidor.leerMonto(value));
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reto 4 · Crypto'),
        actions: [
          IconButton(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar precios',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          const Text('¿Cuántos dólares quieres invertir?',
              style: TextStyle(color: AppColors.textMuted)),
          const SizedBox(height: 8),
          TextField(
            controller: _amountCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: _onAmountChanged,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            decoration: const InputDecoration(
              prefixText: 'USD  ',
            ),
          ),
          const SizedBox(height: 20),
          FutureBuilder<List<Coin>>(
            future: _future,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const LoadingView(label: 'Trayendo precios...');
              }
              if (snap.hasError) {
                return ErrorView(message: snap.error.toString(), onRetry: _refresh);
              }
              return Column(
                children: [
                  for (final c in snap.data!) ...[
                    _CoinRow(coin: c, usd: _usd),
                    const SizedBox(height: 10),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: 10),
          const EndpointNote(
              'GET api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,solana&vs_currencies=usd'),
        ],
      ),
    );
  }
}

class _CoinRow extends StatelessWidget {
  final Coin coin;
  final double usd;
  const _CoinRow({required this.coin, required this.usd});

  @override
  Widget build(BuildContext context) {
    final amount = Convertidor.cuantoCompro(usd, coin.priceUsd);
    final up = coin.change24h >= 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: panel(),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.blueSoft,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(coin.symbol,
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: AppColors.navy)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(coin.name,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(
                  '${Convertidor.dinero(coin.priceUsd)}  ${up ? '▲' : '▼'} ${coin.change24h.abs().toStringAsFixed(2)}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: up ? AppColors.green : AppColors.red,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount.toStringAsFixed(6),
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppColors.navy)),
              Text(coin.symbol,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textMuted)),
            ],
          ),
        ],
      ),
    );
  }
}
