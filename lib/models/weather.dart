class Weather {
  final String city;
  final double temp;
  final double feelsLike;
  final int humidity;
  final double windKmh;
  final String description;

  Weather({
    required this.city,
    required this.temp,
    required this.feelsLike,
    required this.humidity,
    required this.windKmh,
    required this.description,
  });

  /// JSON de OpenWeatherMap (/data/2.5/weather)
  factory Weather.fromOpenWeather(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>;
    final wind = json['wind'] as Map<String, dynamic>;
    final desc = (json['weather'] as List).first['description'] as String;
    return Weather(
      city: json['name'] as String,
      temp: (main['temp'] as num).toDouble(),
      feelsLike: (main['feels_like'] as num).toDouble(),
      humidity: (main['humidity'] as num).toInt(),
      windKmh: (wind['speed'] as num).toDouble() * 3.6, // m/s -> km/h
      description: desc[0].toUpperCase() + desc.substring(1),
    );
  }

  /// JSON de Open-Meteo (/v1/forecast con "current=...")
  factory Weather.fromOpenMeteo(String city, Map<String, dynamic> json) {
    final c = json['current'] as Map<String, dynamic>;
    return Weather(
      city: city,
      temp: (c['temperature_2m'] as num).toDouble(),
      feelsLike: (c['apparent_temperature'] as num).toDouble(),
      humidity: (c['relative_humidity_2m'] as num).toInt(),
      windKmh: (c['wind_speed_10m'] as num).toDouble(),
      description: _wmo((c['weather_code'] as num).toInt()),
    );
  }

  static String _wmo(int code) {
    if (code == 0) return 'Despejado';
    if (code <= 2) return 'Parcialmente nublado';
    if (code == 3) return 'Nublado';
    if (code <= 48) return 'Niebla';
    if (code <= 57) return 'Llovizna';
    if (code <= 67) return 'Lluvia';
    if (code <= 77) return 'Nieve';
    if (code <= 82) return 'Chubascos';
    if (code <= 86) return 'Nevadas';
    return 'Tormenta';
  }
}
