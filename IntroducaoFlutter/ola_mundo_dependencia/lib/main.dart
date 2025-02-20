import 'package:flutter/material.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Olá mundo"),
        ),
        body: Center(child: ElevatedButton(onPressed: onPressed, child: child),),
      ),
    )
  }
}
