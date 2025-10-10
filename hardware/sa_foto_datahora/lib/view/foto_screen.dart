import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sa_foto_datahora/controllers/foto_controller.dart';
import 'package:sa_foto_datahora/models/foto.dart';

class FotoScreen extends StatefulWidget {
  const FotoScreen({super.key});
  @override
  State<FotoScreen> createState() => _FotoScreenState();
}

class _FotoScreenState extends State<FotoScreen> {
  final FotoController _controller = FotoController();
  bool _isLoading = false;

  void _capturarFoto() async {
    setState(() {
      _isLoading = true;
    });
    await _controller.tirarFoto();
    setState(() {
      _isLoading = false;
    });
  }

  void _mostrarDetalhes(BuildContext context, Foto foto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.file(foto.imagem),
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Cidade: ${foto.cidade}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Text(
                'Data: ${DateFormat('dd/MM/yyyy HH:mm').format(foto.dataHora)}',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Galeria de Fotos',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 23, 142, 240),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _controller.fotos.isEmpty
          ? Center(child: Text('Nenhuma foto tirada ainda.'))
          : GridView.builder(
              padding: EdgeInsets.all(4.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: _controller.fotos.length,
              itemBuilder: (context, index) {
                final foto = _controller.fotos[index];
                return GestureDetector(
                  onTap: () => _mostrarDetalhes(context, foto),
                  child: Image.file(foto.imagem, fit: BoxFit.cover),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : _capturarFoto,
        child: Icon(Icons.camera_alt, color: Colors.white),
        backgroundColor: Color.fromARGB(255, 23, 142, 240)

      ),
    );
  }
}
