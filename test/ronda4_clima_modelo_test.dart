// RETO 3 · Ronda 4: Modelo del clima (lib/models/weather.dart)
import 'package:cuatro_retos/models/weather.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Ronda 4 - Modelo Weather', () {
    test('lee el JSON de OpenWeatherMap', () {
      final w = Weather.fromOpenWeather({
        'name': 'Dolores Hidalgo',
        'main': {'temp': 24.6, 'feels_like': 23.1, 'humidity': 40},
        'wind': {'speed': 10},
        'weather': [
          {'description': 'cielo claro'}
        ],
      });

      expect(w.city, 'Dolores Hidalgo');
      expect(w.temp, 24.6);
      expect(w.humidity, 40);
      expect(w.windKmh, 36); // 10 m/s * 3.6 = 36 km/h
      expect(w.description, 'Cielo claro'); // primera letra en mayuscula
    });

    test('lee el JSON de Open-Meteo y traduce el codigo del clima', () {
      Weather conCodigo(int codigo) => Weather.fromOpenMeteo('Leon', {
            'current': {
              'temperature_2m': 18,
              'apparent_temperature': 17,
              'relative_humidity_2m': 55,
              'wind_speed_10m': 12,
              'weather_code': codigo,
            }
          });

      expect(conCodigo(0).description, 'Despejado');
      expect(conCodigo(3).description, 'Nublado');
      expect(conCodigo(61).description, 'Lluvia');
      expect(conCodigo(95).description, 'Tormenta');
      expect(conCodigo(0).city, 'Leon');
      expect(conCodigo(0).temp, 18);
    });
  });
}
