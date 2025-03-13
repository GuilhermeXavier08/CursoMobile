import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Exemplo Widgets de Exibição",
            style: TextStyle(fontSize: 35),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Column(
            children: [
              Text(
                "Olá mundo",
                style: TextStyle(fontSize: 40, color: Colors.green),
              ),
              Text(
                "Sla",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.amberAccent,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 50),
              Image.network(
                "https://m.media-amazon.com/images/S/pv-target-images/c463b0484625cf33bf558a0046b1e0d9a8c887843367c296169d3ba777c62a9a.jpg",
                width: 400,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 50),
              Image.asset(
                "assets/img/eusabo.png",
                width: 400,
                fit: BoxFit.cover,
              ),
              Icon(Icons.star,
              size: 100,
              color: Colors.yellow
              )
            ],
          ),
        ),
      ),
    );
  }
}
