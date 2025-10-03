import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:sa_geolocator_maps/models/location_points.dart';

class MapController {
  final DateFormat _formatar = DateFormat("dd/MM/yyyy - HH:mm:ss");

  Future<LocationPoints> getCurrentLocation() async{
    bool serviceEnable = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnable){
      throw Exception("Sem acesso ao GPS");
    }
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission == await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Permissão Negada de Acesso ao GPS");
      }
    }
    Position position = await Geolocator.getCurrentPosition();
    String dataHora = _formatar.format(DateTime.now());

    LocationPoints posicaoAtual = LocationPoints(
      latitude: position.latitude, 
      longitude: position.longitude, 
      timeStamp: dataHora
    );
    return posicaoAtual;
  }
}