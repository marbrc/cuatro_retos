// RETO 3 · Ronda 5: Servicio del clima (lib/services/weather_service.dart)
import 'dart:convert';

import 'package:cuatro_retos/services/api_exception.dart';
import 'package:cuatro_retos/services/weather_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('Ronda 5 - WeatherService', () {
    test('sin llave usa Open-Meteo en 2 pasos (ciudad -> coordenadas -> clima)',
        () async {
      final cliente = MockClient((req) async {
        if (req.url.host == 'geocoding-api.open-meteo.com') {
          return http.Response(
              jsonEncode({
                'results': [
                  {'name': 'Dolores Hidalgo', 'latitude': 21.15, 'longitude': -100.93}
                ]
              }),
              200);
        }
        expect(req.url.host, 'api.open-meteo.com');
        expect(req.url.queryParameters['latitude'], '21.15');
        return http.Response(
            jsonEncode({
              'current': {
                'temperature_2m': 22,
                'apparent_temperature': 21,
                'relative_humidity_2m': 30,
                'wind_speed_10m': 8,
                'weather_code': 0,
              }
            }),
            200);
      });

      final servicio = WeatherService(client: cliente, openWeatherKey: '');
      final w = await servicio.fetchByCity('Dolores Hidalgo');

      expect(w.city, 'Dolores Hidalgo');
      expect(w.temp, 22);
      expect(w.description, 'Despejado');
    });

    test('con llave usa OpenWeatherMap', () async {
      final cliente = MockClient((req) async {
        expect(req.url.host, 'api.openweathermap.org');
        expect(req.url.queryParameters['units'], 'metric');
        return http.Response(
            jsonEncode({
              'name': 'Guanajuato',
              'main': {'temp': 20, 'feels_like': 19, 'humidity': 50},
              'wind': {'speed': 2},
              'weather': [
                {'description': 'nubes'}
              ],
            }),
            200);
      });

      final servicio = WeatherService(client: cliente, openWeatherKey: 'demo');
      final w = await servicio.fetchByCity('Guanajuato');
      expect(w.city, 'Guanajuato');
    });

    test('ciudad que no existe da error', () {
      final cliente = MockClient((_) async => http.Response('{}', 200));
      final servicio = WeatherService(client: cliente, openWeatherKey: '');
      expect(servicio.fetchByCity('Ciudadquenoexiste'),
          throwsA(isA<ApiException>()));
    });

    test('campo vacio da error', () {
      final servicio = WeatherService(openWeatherKey: '');
      expect(servicio.fetchByCity('   '), throwsA(isA<ApiException>()));
    });
  });
}
