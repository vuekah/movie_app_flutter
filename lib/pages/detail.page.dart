import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movie_app_flutter/model/get_genre.utils.dart';
import 'package:movie_app_flutter/model/movie.model.dart';
import 'package:movie_app_flutter/pages/widgets/item_movie.widget.dart';
import 'package:movie_app_flutter/service/movie.service.dart';

class DetailPage extends StatefulWidget {
  final MovieModel movie;

  const DetailPage({super.key, required this.movie});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late int runtime = 0;

  void fetchRuntime() async {
    int time = await MovieService().fetchDetailMovie(movieId: widget.movie.id!);
    setState(() {
      runtime = time;
    });
  }

  @override
  void initState() {
    fetchRuntime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final isIOS = Platform.isIOS;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail"),
        actions: const [
          Icon(Icons.bookmark, size: 28),
          SizedBox(width: 15),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildBackdropImage(context, size, padding,isIOS),
            _buildMovieDetails(context, size, padding,isIOS),
            const SizedBox(
              height: 60,
            ),
            _buildInforMovie(),
            Padding(padding: EdgeInsets.all(24),child: Text(widget.movie.overview!),)
          ],
        ),
      ),
    );
  }

  Widget _buildInforMovie() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildReleaseDateRow(),
        Container(
          width: 1,
          height: 16,
          color: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 8),
        ),
        _buildTimeRow(),
        Container(
          width: 1,
          height: 16,
          color: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 8),
        ),
        _buildActionRow(),
      ],
    );
  }

  Widget _buildTimeRow() {
    return RowItem(
      icon: Icons.schedule,
      title: "$runtime minutes",
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

  Widget _buildBackdropImage(
      BuildContext context, Size size, EdgeInsets padding,bool isIos) {
    final imageUrl = widget.movie.backdropPath != null
        ? "https://image.tmdb.org/t/p/w1280${widget.movie.backdropPath}"
        : "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/no-pictures-sign-poster-template-19dc5eedf6a59578abe0de03d05d1e9e_screen.jpg?ts=1636971292";

    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: const BorderRadiusDirectional.only(
            bottomStart: Radius.circular(20),
            bottomEnd: Radius.circular(20),
          ),
          child: Image.network(
            imageUrl,
            height: size.height < size.width ? 200 : size.height * 0.25,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          right: size.height < size.width ? (isIos?padding.left:padding.top) : 20,
          bottom: 10,
          child: _buildRating(),
        ),
        Positioned(
          bottom: -65,
          left: size.height < size.width ? (isIos?padding.left:padding.top) : 20,
          child: _buildPoster(),
        ),
      ],
    );
  }

  Widget _buildRating() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 9),
      decoration: BoxDecoration(
        color: const Color(0x32252836),
        borderRadius: BorderRadius.circular(8),
      ),
      child: RowItem(
        icon: Icons.star_border_outlined,
        color: const Color(0xFFFF8700),
        title: widget.movie.voteAverage?.toStringAsFixed(1) ?? "N/A",
      ),
    );
  }

  Widget _buildPoster() {
    final imageUrl = widget.movie.posterPath != null
        ? "https://image.tmdb.org/t/p/w500${widget.movie.posterPath}"
        : "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/no-pictures-sign-poster-template-19dc5eedf6a59578abe0de03d05d1e9e_screen.jpg?ts=1636971292";

    return Hero(
      tag: "${widget.movie.title}",
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          imageUrl,
          width: 120,
          height: 150,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  Widget _buildMovieDetails(
      BuildContext context, Size size, EdgeInsets padding,bool isIos) {
    return Padding(
      padding: EdgeInsets.only(
          left: size.height < size.width ? (isIos?padding.left:padding.top)+130 : 150),
      child: Row(
        children: [
          Flexible(
            child: Text(
              widget.movie.title ?? "N/A",
              style: const TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
