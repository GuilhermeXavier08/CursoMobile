import 'dart:convert';

void main() {
  //string no Formato Json ->
  String jsonString = '''{
                          "usuario":"João",
                          "login":"joao_user",
                          "senha":1234,
                          "ativo":true
                          }''';
  //converti a String em Map -> usando  Json. Convert (decode)
  Map<String, dynamic> usuario = json.decode(jsonString);
  //acesso aos elementos (atributos) do json
  print(usuario["ativo"]);
  //manipulando Json usando o Map
  usuario["ativo"] = false;

  //fazer o encode Map -> Json(texto)
  jsonString = json.encode(usuario);

  //mostrar o texto no formato JSON
  print(jsonString);
}
