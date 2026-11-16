/// La matemática del Reto 4, separada de la pantalla para poder probarla.
class Convertidor {
  /// Cuántas monedas compras con [usd] dólares si cada una cuesta [precio].
  static double cuantoCompro(double usd, double precio) {
    if (usd <= 0 || precio <= 0) return 0;
    return usd / precio;
  }

  /// Convierte lo que escribió el usuario en número.
  /// double.tryParse no truena: si no es número regresa null, y ahí usamos 0.
  static double leerMonto(String texto) {
    return double.tryParse(texto.trim().replaceAll(',', '.')) ?? 0;
  }

  /// 1234567.891 -> $1,234,567.89
  static String dinero(double valor) {
    final partes = valor.toStringAsFixed(2).split('.');
    final enteros = partes[0];
    final buf = StringBuffer();
    for (var i = 0; i < enteros.length; i++) {
      if (i > 0 && (enteros.length - i) % 3 == 0) buf.write(',');
      buf.write(enteros[i]);
    }
    return '\$${buf.toString()}.${partes[1]}';
  }
}
