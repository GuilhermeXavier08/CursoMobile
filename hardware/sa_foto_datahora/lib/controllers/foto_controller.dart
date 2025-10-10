import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sa_foto_datahora/controllers/location_controller.dart';
import 'package:sa_foto_datahora/models/foto.dart';

class FotoController {
  final List<Foto> _fotos = [];
  final ImagePicker _picker = ImagePicker();
  final LocationController _locationController = LocationController();

  List<Foto> get fotos => _fotos;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  Future<Position?> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) {
      return null;
    }
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> tirarFoto() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile == null) return;

    Position? position = await _getCurrentPosition();
    if (position == null) return;

    String? cidade = await _locationController.getCidade(
      position.latitude,
      position.longitude,
    );

    if (cidade != null) {
      final novaFoto = Foto(
        imagem: File(pickedFile.path),
        dataHora: DateTime.now(),
        cidade: cidade,
      );
      _fotos.add(novaFoto);
    }
  }
}