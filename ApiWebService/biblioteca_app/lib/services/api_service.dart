import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const _baseUrl = "http://10.109.197.4:3014";

  static Future<List<dynamic>> getList(String path) async{
    final res = await http.get(Uri.parse("$_baseUrl/$path"));
    if (res.statusCode == 200) return json.decode(res.body);
    throw Exception("Falha ao carregar lista de $path");
  }

  static Future<Map<String,dynamic>> getOne(String path, String id) async{
    final res = await http.get(Uri.parse("$_baseUrl/$path/$id"));
    if(res.statusCode == 200) return json.decode(res.body);
    throw Exception("Erro ao carregar recurso de $path");
}

  static Future<Map<String,dynamic>> post(String path, Map<String,dynamic> body) async{
    final res = await http.post(
      Uri.parse("$_baseUrl/$path"),
      headers: {"Content-Type":"application/json"},
      body: json.encode(body)
      );
      if(res.statusCode == 201) return json.decode(res.body);
      throw Exception("Falha ao criar recurso em $path");
  }

  static Future<Map<String,dynamic>> put(String path, Map<String,dynamic> body, String id) async{
    final res = await http.put(
      Uri.parse("$_baseUrl/$path/$id"),
      headers: {"Content-Type":"application/json"},
      body: json.encode(body)
      );
      if(res.statusCode == 200) return json.decode(res.body);
      throw Exception("Falha ao atualizar recurso em $path");
  }

  static delete(String path, String id) async{
    final res = await http.delete(Uri.parse("$_baseUrl/$path/$id"));
    if(res.statusCode != 200) throw Exception("Falha ao deletar recurso de $path");
  }
}