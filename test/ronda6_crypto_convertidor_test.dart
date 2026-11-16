// RETO 4 · Ronda 6: Matemática del convertidor (lib/utils/convertidor.dart)
import 'package:cuatro_retos/utils/convertidor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Ronda 6 - Convertidor', () {
    test('calcula cuantas monedas compras', () {
      expect(Convertidor.cuantoCompro(100, 50), 2);
      expect(Convertidor.cuantoCompro(50, 100), 0.5);
    });

    test('precio o monto en cero o negativo regresa 0', () {
      expect(Convertidor.cuantoCompro(100, 0), 0);
      expect(Convertidor.cuantoCompro(-10, 50), 0);
    });

    test('lee lo que escribe el usuario (double.parse seguro)', () {
      expect(Convertidor.leerMonto('12.5'), 12.5);
      expect(Convertidor.leerMonto(' 100 '), 100);
      expect(Convertidor.leerMonto('12,5'), 12.5);
      expect(Convertidor.leerMonto('abc'), 0);
      expect(Convertidor.leerMonto(''), 0);
    });

    test('formatea dinero con comas', () {
      expect(Convertidor.dinero(5), '\$5.00');
      expect(Convertidor.dinero(1234567.891), '\$1,234,567.89');
    });
  });
}
