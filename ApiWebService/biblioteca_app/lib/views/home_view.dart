import 'package:biblioteca_app/views/emprestimo/lista_emprestimos.dart';
import 'package:biblioteca_app/views/livro/lista_livros.dart';
import 'package:biblioteca_app/views/usuario/lista_usuarios.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _index = 0;
  final List<Widget> _paginas = [
    ListaLivros(),
    ListaEmprestimos(),
    ListaUsuarios(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Gerenciador de Biblioteca",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 5, 102, 180),
      ),
      body: _paginas[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (value) => setState(() => _index = value),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Livros"),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: "Empréstimos",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Usuários"),
        ],
      ),
    );
  }
}
