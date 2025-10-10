import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationController {
  final String _apiKey = "5e5bc0dcaeed5297612e89ec55fd31fa";

  Future<String?> getCidade(double lat, double lon) async {
    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric&lang=pt_br");
    
    try {
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final dados = json.decode(res.body);
        return dados['name'];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}