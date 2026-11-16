// Ronda 8: Manejo de errores de las APIs (lib/services/api_exception.dart)
import 'package:cuatro_retos/services/api_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  final url = Uri.https('ejemplo.com', '/datos');

  Future<dynamic> conCodigo(int codigo, [String body = '{}']) {
    final cliente = MockClient((_) async => http.Response(body, codigo));
    return getJson(url, client: cliente);
  }

  group('Ronda 8 - getJson y errores', () {
    test('200 regresa el JSON convertido', () async {
      final datos = await conCodigo(200, '{"precio": 10}');
      expect(datos['precio'], 10);
    });

    test('cada codigo de error da un mensaje distinto', () async {
      for (final codigo in [401, 404, 429, 500]) {
        try {
          await conCodigo(codigo);
          fail('Debio lanzar ApiException con $codigo');
        } on ApiException catch (e) {
          expect(e.message, contains('$codigo'));
        }
      }
    });

    test('sin internet da mensaje de conexion', () async {
      final cliente = MockClient((_) async => throw Exception('sin red'));
      try {
        await getJson(url, client: cliente);
        fail('Debio lanzar ApiException');
      } on ApiException catch (e) {
        expect(e.message, contains('conexión'));
      }
    });
  });
}
