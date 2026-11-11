import 'dart:math';

import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../services/movie_service.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  final _service = MovieService();
  Mood _mood = moods.first;
  late Future<List<Movie>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchByMood(_mood);
  }

  void _load(Mood mood) {
    setState(() {
      _mood = mood;
      _future = _service.fetchByMood(mood);
    });
  }

  void _showRandom(List<Movie> movies) {
    if (movies.isEmpty) return;
    final m = movies[Random().nextInt(movies.length)];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _MovieDetail(movie: m),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reto 1 · Películas')),
      body: FutureBuilder<List<Movie>>(
        future: _future,
        builder: (context, snap) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            children: [
              const Text('¿Cómo te sientes hoy?',
                  style: TextStyle(color: AppColors.textMuted)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final m in moods)
                    ChoiceChip(
                      label: Text(m.label),
                      selected: m == _mood,
                      onSelected: (_) => _load(m),
                      selectedColor: AppColors.navy,
                      labelStyle: TextStyle(
                        color: m == _mood ? Colors.white : AppColors.text,
                      ),
                      showCheckmark: false,
                      side: const BorderSide(color: AppColors.border),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              if (snap.connectionState == ConnectionState.waiting)
                const LoadingView(label: 'Buscando películas...')
              else if (snap.hasError)
                ErrorView(
                  message: snap.error.toString(),
                  onRetry: () => _load(_mood),
                )
              else ...[
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => _showRandom(snap.data ?? []),
                    icon: const Icon(Icons.shuffle, size: 18),
                    label: const Text('Elegir una al azar'),
                  ),
                ),
                const SizedBox(height: 16),
                for (final movie in snap.data ?? <Movie>[]) ...[
                  _MovieCard(movie: movie),
                  const SizedBox(height: 10),
                ],
              ],
            ],
          );
        },
      ),
    );
  }
}

class _Poster extends StatelessWidget {
  final String? url;
  final double width;
  const _Poster({required this.url, required this.width});

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: width,
      height: width * 1.5,
      color: AppColors.blueSoft,
      child: const Icon(Icons.movie_outlined, color: AppColors.sky),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: url == null
          ? placeholder
          : Image.network(
              url!,
              width: width,
              height: width * 1.5,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => placeholder,
            ),
    );
  }
}

class _MovieCard extends StatelessWidget {
  final Movie movie;
  const _MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: panel(),
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Poster(url: movie.posterUrl, width: 80),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 15)),
                const SizedBox(height: 4),
                Text('${movie.year}  ·  ★ ${movie.rating.toStringAsFixed(1)}',
                    style: const TextStyle(
                        color: AppColors.textMuted, fontSize: 13)),
                const SizedBox(height: 6),
                Text(
                  movie.overview.isEmpty ? 'Sin sinopsis.' : movie.overview,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieDetail extends StatelessWidget {
  final Movie movie;
  const _MovieDetail({required this.movie});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tu película de hoy',
                style: TextStyle(color: AppColors.textMuted)),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Poster(url: movie.posterUrl, width: 120),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(movie.title,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy)),
                      const SizedBox(height: 6),
                      Text(
                          '${movie.year}  ·  ★ ${movie.rating.toStringAsFixed(1)}',
                          style: const TextStyle(color: AppColors.textMuted)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(movie.overview.isEmpty ? 'Sin sinopsis.' : movie.overview,
                style: const TextStyle(height: 1.45)),
          ],
        ),
      ),
    );
  }
}
