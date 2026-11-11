import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

/// Error "bonito" para mostrar en pantalla.
class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

/// Hace un GET y regresa el JSON ya convertido (Map o List).
/// Si algo falla, lanza ApiException con un mensaje entendible.
Future<dynamic> getJson(Uri url) async {
  final http.Response res;
  try {
    res = await http.get(url).timeout(const Duration(seconds: 12));
  } on TimeoutException {
    throw ApiException('El servidor tardó demasiado. Intenta otra vez.');
  } catch (_) {
    throw ApiException('No hay conexión a internet o el servidor no responde.');
  }

  switch (res.statusCode) {
    case 200:
      return jsonDecode(res.body);
    case 401:
      throw ApiException('La API key no es válida (error 401). Revisa config/api_keys.dart.');
    case 404:
      throw ApiException('No se encontró lo que buscabas (error 404).');
    case 429:
      throw ApiException('Demasiadas peticiones seguidas (error 429). Espera un minuto.');
    default:
      throw ApiException('El servidor respondió con error ${res.statusCode}.');
  }
}
