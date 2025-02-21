import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("App Olá mundo"),
        ),
        body: Center(child: 
          ElevatedButton(onPressed: () {
              Fluttertoast.showToast(
                msg: "Olá, Mundo!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
              );
            },
           child: Text("Mostrar mensagem!"))
        ),
      ),
    );
  }
}