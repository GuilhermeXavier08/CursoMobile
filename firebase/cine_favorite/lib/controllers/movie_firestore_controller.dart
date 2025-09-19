//gerenciar o relacionamento do modelo com o firestore la do firebase
import 'dart:io';

import 'package:cine_favorite/models/movie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class MovieFirestoreController {
  //atributos
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  //criar um metodo para pegar o usuario logado
  User? get currentUser => _auth.currentUser;

  //metodo para pegar os filmes da colecao de favoritos do usuario
  //Stream => criar um ouvinte(listener => pegar a lista de favoritos sempre que for modificado)
  Stream<List<Movie>> getFavoriteMovies() {
    //lista salva no firestore
    if (currentUser == null) return Stream.value([]);
    return _db
        .collection("usuarios")
        .doc(currentUser!.uid)
        .collection("favorite_movies")
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Movie.fromMap(doc.data())).toList(),
        );
    //retorna a colecao que estava em json => convertida em obj em uma lista de filmes
  }

  //path e path_provider (bibliotecas que permite acesso as pastas do dispositivos)
  //adicionar um filme a lista de favoritos
  void addFavoriteMovie(Map<String, dynamic> movieData) async {
    //verificar se o filme tem poster(imagem da capa)
    if (movieData["poster_path"] == null) return;

    //vou armazenar a capa do filme no meu dispositivo
    //baixando a imagem da internet
    final imageUrl =
        "https://image.tmdb.org/t/p/w500${movieData["poster_path"]}";
    // https://image.tmdb.org/t/p/w500/wd7b4Nv9QBHDTIjc2m7sr0IUMoh.jpg
    final responseImg = await http.get(Uri.parse(imageUrl));

    // armazenar a imagem no diretorio do aplicativo
    final imgDir = await getApplicationDocumentsDirectory();
    //baixando a imagem para o aplicativo
    final file = File("${imgDir.path}/${movieData["id"]}.jpg");
    await file.writeAsBytes(responseImg.bodyBytes);

    //criar o obj do filme
    final movie = Movie(
      id: movieData["id"],
      title: movieData["titulo"],
      posterPath: file.toString(),
    );

    //adicionar o filme no firestore
    await _db
    .collection("usuarios")
    .doc(currentUser!.uid)
    .collection("favorite_movies")
    .doc(movie.id.toString())
    .set(movie.toMap());
  }
}
