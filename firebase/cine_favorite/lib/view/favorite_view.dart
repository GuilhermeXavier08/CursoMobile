// favorite_view.dart

import 'dart:io';
import 'package:cine_favorite/controllers/movie_firestore_controller.dart';
import 'package:cine_favorite/models/movie.dart';
import 'package:flutter/material.dart';
// 1. Importe o pacote de rating
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FavoriteView extends StatefulWidget {
  const FavoriteView({super.key});

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  final _movieFireStoreController = MovieFirestoreController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Movie>>(
        stream: _movieFireStoreController.getFavoriteMovies(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Erro ao carregar a lista de favoritos"));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return Center(child: Text("Nenhum filme adicionado aos favoritos"));
          }
          final favoritesMovies = snapshot.data!;
          return GridView.builder(
            padding: EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.5,
            ),
            itemCount: favoritesMovies.length,
            itemBuilder: (context, index) {
              final movie = favoritesMovies[index];
              return Card(
                clipBehavior:
                    Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child:
                      GestureDetector(
                        onLongPress: () {
                          _movieFireStoreController.removeFavoriteMovie(
                            movie.id,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "'${movie.title}' foi removido dos favoritos!",
                              ),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: Image.file(
                          File(movie.posterPath),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(child: Icon(Icons.error));
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        movie.title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // 2. Adicione o Widget de Rating aqui
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: RatingBar.builder(
                        initialRating: movie.rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 20.0,
                        itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                        itemBuilder: (context, _) =>
                            Icon(Icons.star, color: Colors.amber),
                        onRatingUpdate: (rating) {
                          _movieFireStoreController.updateMovieRating(
                            movie.id,
                            rating,
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
