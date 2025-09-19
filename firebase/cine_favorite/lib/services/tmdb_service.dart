//meu serviço de conexao com a API
import 'dart:convert';

import 'package:http/http.dart' as http;

class TmdbService {
    static const String _apiKey = "https://api.themoviedb.org/3/movie/popular?api_key=1fa5c2d59029fd1c438cc35713720604&language=pt-BR";
    static const String _baseUrl = "https://api.themoviedb.org/3";
    static const String _idioma = "pt-BR";

    //metodo para buscar filme com base no texto

    static Future<List<Map<String,dynamic>>> searchMovies(String query) async{
        //converter string em url
        final apiUrl = Uri.parse("$_baseUrl/search/movie?api_key=$_apiKey&query=$query&language=$_idioma");
        // http.get
        final response = await http.get(apiUrl);
        //se resposta for ok == 200
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          return List<Map<String,dynamic>>.from(data["results"]);
        } else{
            //caso o contrario cria um exception
            throw Exception("Falha ao carregar filmes da API");
        }
    }
}