import '../config/api_keys.dart';
import '../models/weather.dart';
import 'api_exception.dart';

class WeatherService {
  Future<Weather> fetchByCity(String city) async {
    final name = city.trim();
    if (name.isEmpty) throw ApiException('Escribe el nombre de una ciudad.');

    if (ApiKeys.openWeather.isNotEmpty) {
      return _openWeather(name);
    }
    return _openMeteo(name);
  }

  /// Opción A: OpenWeatherMap (necesita API key)
  Future<Weather> _openWeather(String city) async {
    final url = Uri.https('api.openweathermap.org', '/data/2.5/weather', {
      'q': city,
      'appid': ApiKeys.openWeather,
      'units': 'metric',
      'lang': 'es',
    });
    final json = await getJson(url) as Map<String, dynamic>;
    return Weather.fromOpenWeather(json);
  }

  /// Opción B: Open-Meteo (sin API key). Son 2 pasos:
  /// 1) convertir el nombre de la ciudad en coordenadas
  /// 2) pedir el clima con esas coordenadas
  Future<Weather> _openMeteo(String city) async {
    final geoUrl = Uri.https('geocoding-api.open-meteo.com', '/v1/search', {
      'name': city,
      'count': '1',
      'language': 'es',
    });
    final geo = await getJson(geoUrl) as Map<String, dynamic>;
    final results = geo['results'] as List?;
    if (results == null || results.isEmpty) {
      throw ApiException('No encontré la ciudad "$city".');
    }
    final place = results.first as Map<String, dynamic>;

    final url = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': '${place['latitude']}',
      'longitude': '${place['longitude']}',
      'current':
          'temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,wind_speed_10m',
      'timezone': 'auto',
    });
    final json = await getJson(url) as Map<String, dynamic>;
    return Weather.fromOpenMeteo(place['name'] as String, json);
  }
}
