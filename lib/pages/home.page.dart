import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movie_app_flutter/model/movie.model.dart';

import 'package:movie_app_flutter/pages/widgets/item_movie.widget.dart';
import 'package:movie_app_flutter/service/movie.service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MovieModel> list = [];
  bool isEndOfPage = false;
  int _pageIndex = 1;
  final _controller = ScrollController();

  void fetchMovies({required int pageIndex}) async {
    List<MovieModel> newMovies =
        await MovieService().fetchMovies(pageIndex: pageIndex);
    setState(() {
      if (newMovies.isNotEmpty) {
        list.addAll(newMovies);
        isEndOfPage = true;
      } else {
        isEndOfPage = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchMovies(pageIndex: _pageIndex);

    _controller.addListener(() {
      if (_controller.position.pixels >=
              _controller.position.maxScrollExtent * 0.8 &&
          isEndOfPage) {
        _pageIndex++;
        fetchMovies(pageIndex: _pageIndex);
        print("=================LOADING PAGE $_pageIndex");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    final size = MediaQuery.of(context).size;
    final isIOS = Platform.isIOS;

    final horizontalPadding = size.width > 402 ? (isIOS?padding.left:padding.top) : 24.0;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Movies"),
        ),
        body: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          controller: _controller,
          itemBuilder: (context, index) => ItemMovie(
            movie: list[index],
          ),
          separatorBuilder: (context, index) => const SizedBox(
            height: 24,
          ),
          itemCount: list.length,
        ));
  }
}
