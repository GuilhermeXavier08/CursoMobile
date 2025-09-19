//classe de modelagem do obj movie

//receber os dados da api -> enviar os dados para o firestore
class Movie {
  final int id; //id do filme no tmdb
  final String title;
  final String
  posterPath; //caminho da imagem do poster (path de armazenamento interno)
  double rating; //nota que o usuario dara ao filme (0 - 5)

  //construtor
  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    this.rating = 0.0,
  });

  //metodos de conversao de obj <=> json
  // tomap obj -> json
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "posterPath": posterPath,
      "rating": rating,
    };
  }

  //frommap json -> obj
  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map["id"],
      title: map["titulo"],
      posterPath: map["posterPath"],
      rating: (map["rating"] as num).toDouble()
    );
  }
}
