import 'package:flutter/material.dart';

import '../config/api_keys.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final _service = WeatherService();
  final _cityCtrl = TextEditingController(text: 'Dolores Hidalgo');
  late Future<Weather> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchByCity(_cityCtrl.text);
  }

  void _search() {
    FocusScope.of(context).unfocus();
    setState(() => _future = _service.fetchByCity(_cityCtrl.text));
  }

  @override
  void dispose() {
    _cityCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final source = ApiKeys.openWeather.isEmpty ? 'Open-Meteo' : 'OpenWeatherMap';

    return Scaffold(
      appBar: AppBar(title: const Text('Reto 3 · Clima')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _cityCtrl,
                  textInputAction: TextInputAction.search,
                  decoration: const InputDecoration(
                    hintText: 'Ciudad',
                    prefixIcon: Icon(Icons.place_outlined),
                  ),
                  onSubmitted: (_) => _search(),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(onPressed: _search, child: const Text('Buscar')),
            ],
          ),
          const SizedBox(height: 20),
          FutureBuilder<Weather>(
            future: _future,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const LoadingView(label: 'Consultando el clima...');
              }
              if (snap.hasError) {
                return ErrorView(message: snap.error.toString(), onRetry: _search);
              }
              final w = snap.data!;
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: AppColors.navy,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(w.city,
                            style: const TextStyle(
                                color: AppColors.sky, fontSize: 15)),
                        const SizedBox(height: 8),
                        Text('${w.temp.round()}°',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 64,
                              fontWeight: FontWeight.w300,
                              height: 1,
                            )),
                        const SizedBox(height: 8),
                        Text(w.description,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 17)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _Stat('Sensación', '${w.feelsLike.round()}°'),
                      const SizedBox(width: 10),
                      _Stat('Humedad', '${w.humidity}%'),
                      const SizedBox(width: 10),
                      _Stat('Viento', '${w.windKmh.round()} km/h'),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          EndpointNote('Fuente: $source'),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label, value;
  const _Stat(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: panel(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 17)),
          ],
        ),
      ),
    );
  }
}
