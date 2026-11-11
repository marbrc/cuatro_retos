import 'package:flutter/material.dart';

import '../services/cat_service.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class CatsScreen extends StatefulWidget {
  const CatsScreen({super.key});

  @override
  State<CatsScreen> createState() => _CatsScreenState();
}

class _CatsScreenState extends State<CatsScreen> {
  final _textCtrl = TextEditingController();

  String _text = '';
  String _filter = '';
  String _color = 'white';
  int _seed = DateTime.now().millisecondsSinceEpoch;

  static const _filters = {'': 'Normal', 'mono': 'Blanco y negro', 'negate': 'Negativo'};
  static const _colors = {'white': Colors.white, 'black': Colors.black, 'yellow': Colors.yellow};

  String get _url => CatService.buildUrl(
        text: _text,
        filter: _filter,
        fontColor: _color,
        seed: _seed,
      );

  void _applyText() => setState(() => _text = _textCtrl.text);

  void _newCat() =>
      setState(() => _seed = DateTime.now().millisecondsSinceEpoch);

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reto 2 · Memes de gatos')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              color: AppColors.blueSoft,
              height: 320,
              child: Image.network(
                _url,
                key: ValueKey(_url), // si cambia la URL, recarga la imagen
                fit: BoxFit.cover,
                loadingBuilder: (_, child, progress) => progress == null
                    ? child
                    : const Center(child: LoadingView(label: 'Llamando al gato...')),
                errorBuilder: (_, __, ___) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: ErrorView(
                    message: 'No se pudo cargar la imagen del gato.',
                    onRetry: _newCat,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textCtrl,
                  maxLength: 40,
                  decoration: const InputDecoration(
                    hintText: 'Escribe tu frase...',
                    counterText: '',
                  ),
                  onSubmitted: (_) => _applyText(),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(onPressed: _applyText, child: const Text('Poner')),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Filtro', style: TextStyle(color: AppColors.textMuted)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final f in _filters.entries)
                ChoiceChip(
                  label: Text(f.value),
                  selected: _filter == f.key,
                  onSelected: (_) => setState(() => _filter = f.key),
                  selectedColor: AppColors.navy,
                  showCheckmark: false,
                  labelStyle: TextStyle(
                    color: _filter == f.key ? Colors.white : AppColors.text,
                  ),
                  side: const BorderSide(color: AppColors.border),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Color del texto',
              style: TextStyle(color: AppColors.textMuted)),
          const SizedBox(height: 8),
          Row(
            children: [
              for (final c in _colors.entries)
                GestureDetector(
                  onTap: () => setState(() => _color = c.key),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: c.value,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _color == c.key ? AppColors.blue : AppColors.border,
                        width: _color == c.key ? 3 : 1,
                      ),
                    ),
                  ),
                ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: _newCat,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Otro gato'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text('URL que se está pidiendo:',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
          const SizedBox(height: 6),
          EndpointNote(_url),
        ],
      ),
    );
  }
}
