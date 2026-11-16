// RETO 4 · Ronda 7: Servicio de CoinGecko (lib/services/crypto_service.dart)
import 'dart:convert';

import 'package:cuatro_retos/services/api_exception.dart';
import 'package:cuatro_retos/services/crypto_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('Ronda 7 - CryptoService', () {
    test('trae BTC, ETH y SOL en dolares', () async {
      final cliente = MockClient((req) async {
        expect(req.url.host, 'api.coingecko.com');
        expect(req.url.queryParameters['ids'], 'bitcoin,ethereum,solana');
        expect(req.url.queryParameters['vs_currencies'], 'usd');
        return http.Response(
            jsonEncode({
              'bitcoin': {'usd': 50000, 'usd_24h_change': 2.5},
              'ethereum': {'usd': 2500, 'usd_24h_change': -1.0},
              'solana': {'usd': 100},
            }),
            200);
      });

      final monedas = await CryptoService(client: cliente).fetchPrices();

      expect(monedas.length, 3);
      expect(monedas.map((m) => m.symbol), ['BTC', 'ETH', 'SOL']);
      expect(monedas[0].priceUsd, 50000);
      expect(monedas[1].change24h, -1.0);
      expect(monedas[2].change24h, 0); // si no viene el cambio, es 0
    });

    test('demasiadas peticiones (429) da error entendible', () {
      final cliente = MockClient((_) async => http.Response('{}', 429));
      expect(CryptoService(client: cliente).fetchPrices(),
          throwsA(isA<ApiException>()));
    });
  });
}
