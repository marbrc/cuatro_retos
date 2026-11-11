class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final double rating;
  final String releaseDate;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.rating,
    required this.releaseDate,
  });

  /// Convierte un pedacito del JSON de TMDB en un objeto Movie.
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as int,
      title: (json['title'] ?? json['name'] ?? 'Sin título') as String,
      overview: (json['overview'] ?? '') as String,
      posterPath: json['poster_path'] as String?,
      rating: (json['vote_average'] as num?)?.toDouble() ?? 0,
      releaseDate: (json['release_date'] ?? '') as String,
    );
  }

  String? get posterUrl =>
      posterPath == null ? null : 'https://image.tmdb.org/t/p/w500$posterPath';

  String get year => releaseDate.length >= 4 ? releaseDate.substring(0, 4) : '—';
}
