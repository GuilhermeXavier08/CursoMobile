import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  runApp(MaterialApp(home: GaleriaScreen()));
}

class GaleriaScreen extends StatelessWidget {
  final List<String> imagens = [
    'https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0',
    'https://images.unsplash.com/photo-1521747116042-5a810fda9664',
    'https://images.unsplash.com/photo-1504384308090-c894fdcc538d',
    'https://images.unsplash.com/photo-1518837695005-2083093ee35b',
    'https://images.unsplash.com/photo-1512486130939-2c4f79935e43',
    'https://images.unsplash.com/photo-1535279020651-a57c6d4e2021',
    'https://images.unsplash.com/photo-1533090368676-1fd25485dbba',
    'https://images.unsplash.com/photo-1506619216599-9d16d0903dfd',
    'https://images.unsplash.com/photo-1494172961521-33799ddd43a5',
    'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Galeria de Imagens')),
      body: Column(
        children: [
          // Carrossel de imagens
          CarouselSlider(
            options: CarouselOptions(height: 300, autoPlay: true),
            items: imagens.map((url) {
              return Container(
                margin: EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(url, fit: BoxFit.cover, width: 1000),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 16), // Espaço entre o carrossel e a galeria
          // GridView de imagens
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: imagens.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _mostrarImagem(context, imagens[index]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(imagens[index], fit: BoxFit.cover),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarImagem(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Image.network(url),
      ),
    );
  }
}