import 'dart:math';

import 'package:http/http.dart' as http;

import '../config/api_keys.dart';
import '../models/movie.dart';
import 'api_exception.dart';

/// Estado de ánimo -> género de TMDB (los números son los IDs de género de TMDB).
class Mood {
  final String label;
  final int? genreId; // null = tendencias de la semana
  const Mood(this.label, this.genreId);
}

const moods = <Mood>[
  Mood('Tendencias', null),
  Mood('Feliz', 35), // Comedia
  Mood('Romántico', 10749), // Romance
  Mood('Aventurero', 12), // Aventura
  Mood('Con miedo', 27), // Terror
  Mood('Pensativo', 18), // Drama
  Mood('En familia', 10751), // Familiar
];

class MovieService {
  static const _base = 'api.themoviedb.org';

  final http.Client? client;
  final String apiKey;

  MovieService({this.client, String? apiKey})
      : apiKey = apiKey ?? ApiKeys.tmdb;

  Future<List<Movie>> fetchByMood(Mood mood) async {
    if (apiKey.isEmpty) {
      throw ApiException(
          'Falta tu API key de TMDB. Pégala en lib/config/api_keys.dart');
    }

    final Uri url;
    if (mood.genreId == null) {
      // Endpoint de tendencias
      url = Uri.https(_base, '/3/trending/movie/week', {
        'api_key': apiKey,
        'language': 'es-MX',
      });
    } else {
      // Endpoint "discover" filtrando por género, en una página al azar
      url = Uri.https(_base, '/3/discover/movie', {
        'api_key': apiKey,
        'language': 'es-MX',
        'with_genres': '${mood.genreId}',
        'sort_by': 'popularity.desc',
        'page': '${Random().nextInt(5) + 1}',
      });
    }

    final json = await getJson(url, client: client) as Map<String, dynamic>;
    final results = json['results'] as List;
    return results
        .map((e) => Movie.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
