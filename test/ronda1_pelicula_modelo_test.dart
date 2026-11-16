// RETO 1 · Ronda 1: Modelo de película (lib/models/movie.dart)
import 'package:cuatro_retos/models/movie.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Ronda 1 - Modelo Movie', () {
    test('convierte el JSON de TMDB en una pelicula', () {
      final movie = Movie.fromJson({
        'id': 550,
        'title': 'El club de la pelea',
        'overview': 'Un oficinista con insomnio...',
        'poster_path': '/abc.jpg',
        'vote_average': 8.4,
        'release_date': '1999-10-15',
      });

      expect(movie.id, 550);
      expect(movie.title, 'El club de la pelea');
      expect(movie.rating, 8.4);
      expect(movie.year, '1999');
      expect(movie.posterUrl, 'https://image.tmdb.org/t/p/w500/abc.jpg');
    });

    test('sin poster ni fecha no truena', () {
      final movie = Movie.fromJson({'id': 1, 'title': 'Sin datos'});

      expect(movie.posterUrl, isNull);
      expect(movie.year, '—');
      expect(movie.rating, 0);
      expect(movie.overview, '');
    });
  });
}
