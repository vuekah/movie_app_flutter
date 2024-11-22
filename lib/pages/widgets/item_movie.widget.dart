import 'package:flutter/material.dart';
import 'package:movie_app_flutter/model/get_genre.utils.dart';
import 'package:movie_app_flutter/model/movie.model.dart';
import 'package:movie_app_flutter/pages/detail.page.dart';

class ItemMovie extends StatefulWidget {
  final MovieModel movie;

  const ItemMovie({super.key, required this.movie});

  @override
  State<ItemMovie> createState() => _ItemMovieState();
}

class _ItemMovieState extends State<ItemMovie> {            
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToDetailPage(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMoviePoster(),
          const SizedBox(width: 8),
          _buildMovieDetails(context),
        ],
      ),
    );
  }

  void _navigateToDetailPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailPage(movie: widget.movie)),
    );
  }

  Widget _buildMoviePoster() {
    final imageUrl = widget.movie.posterPath != null
        ? "https://image.tmdb.org/t/p/w500${widget.movie.posterPath}"
        : "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/no-pictures-sign-poster-template-19dc5eedf6a59578abe0de03d05d1e9e_screen.jpg?ts=1636971292";

    return Hero(
      tag: "${widget.movie.title}",
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          imageUrl,
          width: 110,
          height: 140,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildMovieDetails(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMovieTitle(),
          const SizedBox(height: 14),
          _buildRatingRow(),
          const SizedBox(height: 2),
          _buildActionRow(),
          const SizedBox(height: 5),
          _buildReleaseDateRow(),
        ],
      ),
    );
  }

  Widget _buildMovieTitle() {
    return Text(
      widget.movie.title ?? "N/A",
      style: const TextStyle(
        fontFamily: "Poppins",
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildRatingRow() {
    return RowItem(
      icon: Icons.star_border_outlined,
      color: const Color(0xFFFF8700),
      title: widget.movie.voteAverage?.toStringAsFixed(1) ?? "N/A",
    );
  }

  Widget _buildActionRow() {
    int genreId = (widget.movie.genreIds?.isNotEmpty ?? false)
        ? widget.movie.genreIds![0]
        : 999;
    return RowItem(
      icon: Icons.confirmation_num_outlined,
      title: GenreUtils.getGenreName(genreId),
    );
  }

  Widget _buildReleaseDateRow() {
    final releaseYear =
        widget.movie.releaseDate?.toString().split("-")[0] ?? "N/A";
    return RowItem(
      icon: Icons.calendar_today_outlined,
      title: releaseYear,
    );
  }

  
}

class RowItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? color;

  const RowItem({
    super.key,
    required this.icon,
    required this.title,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 18,
        ),
        const SizedBox(width: 2),
        Text(
          title,
          style: TextStyle(
            color: color,
            fontFamily:
                icon == Icons.star_border_outlined ? "Montserrat" : "Poppins",
            fontWeight: icon == Icons.star_border_outlined
                ? FontWeight.w700
                : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
