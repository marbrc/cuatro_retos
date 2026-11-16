// RETO 2 · Ronda 3: URL dinámica de Cataas (lib/services/cat_service.dart)
import 'package:cuatro_retos/services/cat_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Ronda 3 - CatService.buildUrl', () {
    test('sin texto pide un gato normal', () {
      final url = CatService.buildUrl(
          text: '', filter: '', fontColor: 'white', seed: 1);

      expect(url, startsWith('https://cataas.com/cat?'));
      expect(url, isNot(contains('says')));
      expect(url, isNot(contains('fontSize')));
    });

    test('con texto lo pone en la URL (los espacios se codifican)', () {
      final url = CatService.buildUrl(
          text: 'hola mundo', filter: '', fontColor: 'white', seed: 1);

      expect(url, contains('/cat/says/hola%20mundo'));
      expect(url, contains('fontColor=white'));
    });

    test('solo espacios cuenta como sin texto', () {
      final url = CatService.buildUrl(
          text: '    ', filter: '', fontColor: 'white', seed: 1);
      expect(url, startsWith('https://cataas.com/cat?'));
    });

    test('agrega el filtro solo si se eligio uno', () {
      final conFiltro = CatService.buildUrl(
          text: '', filter: 'mono', fontColor: 'white', seed: 1);
      final sinFiltro = CatService.buildUrl(
          text: '', filter: '', fontColor: 'white', seed: 1);

      expect(conFiltro, contains('filter=mono'));
      expect(sinFiltro, isNot(contains('filter=')));
    });

    test('otra semilla = otra URL (nuevo gato)', () {
      final a = CatService.buildUrl(
          text: 'miau', filter: '', fontColor: 'white', seed: 1);
      final b = CatService.buildUrl(
          text: 'miau', filter: '', fontColor: 'white', seed: 2);
      expect(a, isNot(equals(b)));
    });
  });
}
