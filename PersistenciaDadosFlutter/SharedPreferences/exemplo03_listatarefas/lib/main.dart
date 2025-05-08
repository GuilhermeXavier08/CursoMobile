import 'package:exemplo03_listatarefas/telaCadastro.dart';
import 'package:exemplo03_listatarefas/telaInicial.dart';
import 'package:exemplo03_listatarefas/telaTarefas.dart';
import 'package:flutter/material.dart';

void main(){
    runApp(MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: {
            "/": (context)=>Telainicial(),
            "/cadastro": (context)=>TelaCadastro(),
            "/tarefas": (context)=>TelaTarefas()
        },
        theme: ThemeData(brightness: Brightness.light),
        darkTheme: ThemeData(brightness: Brightness.dark),

    ));
}