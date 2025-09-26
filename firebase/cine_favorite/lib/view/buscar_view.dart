import 'package:cine_favorite/controllers/movie_firestore_controller.dart';
import 'package:cine_favorite/services/tmdb_service.dart';
import 'package:flutter/material.dart';

class BuscarView extends StatefulWidget {
  const BuscarView({super.key});

  @override
  State<BuscarView> createState() => _BuscarViewState();
}

class _BuscarViewState extends State<BuscarView> {
  final _movieFireStoreController = MovieFirestoreController();
  final _searchField = TextEditingController();
  List<Map<String, dynamic>> _movies = [];
  bool _isLoading = false;

  void _searchMovies() async {
    final query = _searchField.text.trim();
    if (query.isEmpty) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final result = await TmdbService.searchMovies(query);
      setState(() {
        //passa o resultado da busca para a lista
        _movies = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _movies = [];
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Deu erro kk")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchField,
              decoration: InputDecoration(
                labelText: "Nome do Filme",
                border: OutlineInputBorder(),
                suffix: IconButton(
                  onPressed: _searchMovies,
                  icon: Icon(Icons.search),
                ),
              ),
            ),
            SizedBox(height: 10),
            _isLoading
                ? CircularProgressIndicator()
                : _movies.isEmpty
                ? Text("Nenhum filme encontrado")
                : Expanded(
                    child: ListView.builder(
                      itemCount: _movies.length,
                      itemBuilder: (context, index) {
                        final movie = _movies[index];
                        return ListTile(
                          leading: Image.network(
                            "https://image.tmdb.org/t/p/w500${movie["poster_path"]}",
                            height: 50,
                          ),
                          title: Text(movie["title"]),
                          subtitle: Text(movie["release_date"]),
                          trailing: IconButton(
                            onPressed: () async {
                              _movieFireStoreController.addFavoriteMovie(movie);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "${movie["title"]} foi adicionando com sucesso",
                                  ),
                                ),
                              );
                            },
                            icon: Icon(Icons.add),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
