class Coin {
  final String id; // como lo llama CoinGecko: bitcoin, ethereum, solana
  final String name;
  final String symbol;
  final double priceUsd;
  final double change24h;

  Coin({
    required this.id,
    required this.name,
    required this.symbol,
    required this.priceUsd,
    required this.change24h,
  });
}
