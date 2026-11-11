import '../models/coin.dart';
import 'api_exception.dart';

class CryptoService {
  static const _coins = {
    'bitcoin': ['Bitcoin', 'BTC'],
    'ethereum': ['Ethereum', 'ETH'],
    'solana': ['Solana', 'SOL'],
  };

  /// Endpoint: /api/v3/simple/price?ids=bitcoin,ethereum,solana&vs_currencies=usd
  /// Respuesta: { "bitcoin": { "usd": 67000, "usd_24h_change": 1.2 }, ... }
  Future<List<Coin>> fetchPrices() async {
    final url = Uri.https('api.coingecko.com', '/api/v3/simple/price', {
      'ids': _coins.keys.join(','),
      'vs_currencies': 'usd',
      'include_24hr_change': 'true',
    });

    final json = await getJson(url) as Map<String, dynamic>;

    return _coins.entries.map((e) {
      final data = json[e.key] as Map<String, dynamic>;
      return Coin(
        id: e.key,
        name: e.value[0],
        symbol: e.value[1],
        priceUsd: (data['usd'] as num).toDouble(),
        change24h: (data['usd_24h_change'] as num?)?.toDouble() ?? 0,
      );
    }).toList();
  }
}
