import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'cats_screen.dart';
import 'crypto_screen.dart';
import 'movies_screen.dart';
import 'weather_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final retos = <_Reto>[
      _Reto('01', 'Películas del fin de semana', 'TMDB · según tu ánimo',
          Icons.movie_outlined, const MoviesScreen()),
      _Reto('02', 'Memes de gatos', 'Cataas · texto y filtros',
          Icons.pets_outlined, const CatsScreen()),
      _Reto('03', 'Clima', 'OpenWeatherMap / Open-Meteo',
          Icons.wb_cloudy_outlined, const WeatherScreen()),
      _Reto('04', 'Convertidor crypto', 'CoinGecko · BTC, ETH, SOL',
          Icons.currency_bitcoin, const CryptoScreen()),
    ];

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
          children: [
            const Text('Cuatro retos',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                  letterSpacing: -0.5,
                )),
            const SizedBox(height: 6),
            const Text(
              'Cuatro mini apps que consumen APIs públicas.',
              style: TextStyle(color: AppColors.textMuted, fontSize: 15),
            ),
            const SizedBox(height: 24),
            for (final r in retos) ...[
              _RetoTile(reto: r),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}

class _Reto {
  final String number, title, subtitle;
  final IconData icon;
  final Widget screen;
  _Reto(this.number, this.title, this.subtitle, this.icon, this.screen);
}

class _RetoTile extends StatelessWidget {
  final _Reto reto;
  const _RetoTile({required this.reto});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => reto.screen),
        ),
        child: Ink(
          decoration: panel(),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(reto.number,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w300,
                    color: AppColors.sky,
                  )),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(reto.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        )),
                    const SizedBox(height: 2),
                    Text(reto.subtitle,
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.textMuted)),
                  ],
                ),
              ),
              Icon(reto.icon, color: AppColors.blue),
            ],
          ),
        ),
      ),
    );
  }
}
