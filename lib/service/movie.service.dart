import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:movie_app_flutter/model/movie.model.dart';

class MovieService {
  Future<List<MovieModel>> fetchMovies({required int pageIndex}) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/upcoming?api_key=ff3a62ac4d904a8f37c2820a45bd98f2&language=en-US&page=$pageIndex'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<MovieModel> movies = (data['results'] as List)
          .map((movieJson) => MovieModel.fromJson(movieJson))
          .toList();
      return movies;
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<int> fetchDetailMovie({required int movieId}) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId?language=en-US&&api_key=ff3a62ac4d904a8f37c2820a45bd98f2'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['runtime'] as int;
    } else {
      throw Exception('Failed to load movies');
    }
  }


}
