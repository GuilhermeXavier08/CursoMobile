import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
void main(){
  runApp(
    MaterialApp(
      home: ImagePickerScreen(),
    )
  );
}

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  File? _image;
  final _picker = ImagePicker();

  void _getImageFromCamera() async{
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _getImageFromGaleria() async{
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exemplo Imagem Picked", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 18, 136, 233),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null ? Image.file(_image!, height: 500,)
            : Text("Nenhuma Imagem Selecionada"),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: _getImageFromCamera, child: Text("Tirar Foto")),
            SizedBox(height:10),
            ElevatedButton(onPressed: _getImageFromGaleria, child: Text("Escolher da Galeria"))

          ],
        ),
      ),
    );
  }
}