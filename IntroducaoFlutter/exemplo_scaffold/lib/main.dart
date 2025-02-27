import 'package:flutter/material.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Minha Aplicação', style: TextStyle(fontSize: 25)),
          centerTitle: true,
          backgroundColor: Colors.blue,
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                print('Clicou na lupa');
              },
            ),
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                print('Clicou no sino');
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [Text("Inicio"), Text("Conteúdo"), Text("Contato")],
          ),
        ),

        body: Center(
          
          child: ElevatedButton(
            
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Ação realizada com sucesso!')),
              );
            },
            child: Text('Mostrar SnackBar'),
          ),
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print("Botão pressionado");
          },
          child: Icon(Icons.add),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
          ],
        ),
      ),
    );
  }
}
