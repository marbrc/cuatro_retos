/// Cataas no regresa JSON: regresa directamente una IMAGEN.
/// Por eso aquí solo "armamos" la URL y Flutter la pinta con Image.network.
class CatService {
  static String buildUrl({
    required String text,
    required String filter, // '' | 'mono' | 'negate'
    required String fontColor, // 'white' | 'black' | 'yellow'...
    required int seed, // cambia para que no salga el mismo gato (caché)
  }) {
    final clean = text.trim();
    final path =
        clean.isEmpty ? '/cat' : '/cat/says/${Uri.encodeComponent(clean)}';

    final params = <String, String>{
      if (clean.isNotEmpty) 'fontSize': '40',
      if (clean.isNotEmpty) 'fontColor': fontColor,
      if (filter.isNotEmpty) 'filter': filter,
      'width': '600',
      't': '$seed',
    };

    final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    return 'https://cataas.com$path?$query';
  }
}
