// RETO 1 · Ronda 2: Servicio de TMDB (lib/services/movie_service.dart)
import 'dart:convert';

import 'package:cuatro_retos/services/api_exception.dart';
import 'package:cuatro_retos/services/movie_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  final respuesta = jsonEncode({
    'results': [
      {'id': 1, 'title': 'Pelicula A', 'vote_average': 7.5},
      {'id': 2, 'title': 'Pelicula B', 'vote_average': 6.0},
    ]
  });

  group('Ronda 2 - MovieService', () {
    test('estado de animo "Feliz" pide el genero 35 (comedia)', () async {
      final cliente = MockClient((req) async {
        expect(req.url.host, 'api.themoviedb.org');
        expect(req.url.path, '/3/discover/movie');
        expect(req.url.queryParameters['with_genres'], '35');
        expect(req.url.queryParameters['api_key'], 'llave-demo');
        return http.Response(respuesta, 200);
      });

      final servicio = MovieService(client: cliente, apiKey: 'llave-demo');
      final feliz = moods.firstWhere((m) => m.label == 'Feliz');
      final pelis = await servicio.fetchByMood(feliz);

      expect(pelis.length, 2);
      expect(pelis.first.title, 'Pelicula A');
    });

    test('"Tendencias" usa el endpoint de trending', () async {
      final cliente = MockClient((req) async {
        expect(req.url.path, '/3/trending/movie/week');
        return http.Response(respuesta, 200);
      });

      final servicio = MovieService(client: cliente, apiKey: 'llave-demo');
      final pelis = await servicio.fetchByMood(moods.first);
      expect(pelis, isNotEmpty);
    });

    test('sin API key avisa con un error', () {
      final servicio = MovieService(apiKey: '');
      expect(servicio.fetchByMood(moods.first), throwsA(isA<ApiException>()));
    });

    test('llave incorrecta (401) da error entendible', () {
      final cliente = MockClient((_) async => http.Response('{}', 401));
      final servicio = MovieService(client: cliente, apiKey: 'mala');
      expect(servicio.fetchByMood(moods.first), throwsA(isA<ApiException>()));
    });
  });
}
