import 'package:flutter/material.dart';
import 'package:sa06_dashboardresponsivo/login.dart'; // Login Page
import 'package:sa06_dashboardresponsivo/tarefas.dart'; // Tarefas Page
import 'package:sa06_dashboardresponsivo/vertarefas.dart'; // VerTarefas Page

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (context) => Login(),          // Rota inicial para Login
        "/tarefas": (context) => ListaTarefas(),  // Rota para Tarefas
        "/vertarefas": (context) => VerTarefas(), // Rota para VerTarefas
      },
    ),
  );
}
