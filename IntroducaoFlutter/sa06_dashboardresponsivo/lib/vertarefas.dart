import 'package:flutter/material.dart';

// Classe principal do Widget VerTarefas
class VerTarefas extends StatefulWidget {
  @override
  _VerTarefasState createState() => _VerTarefasState();
}

// Estado do Widget VerTarefas
class _VerTarefasState extends State<VerTarefas> {
  // Lista de tarefas pendentes
  final List<String> _pendentes = [
    "Arrumar o Quarto",
    "Passear com o Cachorro",
    "Lavar a Louça",
    "Varrer a Casa",
    "Aspirar o Pó",
    "Tirar o Lixo para fora"
  ];

  // Lista de tarefas concluídas
  final List<String> _concluidas = [
    "Dar Banho no Cachorro",
    "Fazer Dever de Casa",
    "Estender a Roupa no Varal",
    "Regar as Plantas",
    "Fazer Almoço",
    "Pagar as Contas"
  ];

  // Variável para controlar o modo de tema (escuro/claro)
  bool _modoEscuro = false;

  @override
  Widget build(BuildContext context) {
    // Definindo a cor do texto e fundo com base no modo de tema
    Color textoPrincipal = _modoEscuro ? Colors.white : Colors.black;
    Color fundo = _modoEscuro ? const Color(0xFF323232) : Colors.white;

    // Scaffold cria a estrutura básica da página
    return Scaffold(
      backgroundColor: fundo, // Cor de fundo ajustada conforme o modo
      appBar: AppBar(
        backgroundColor: Colors.blue, // Cor da barra de navegação
        title: Text(
          "INFORMAÇÕES",
          style: TextStyle(
            color: Colors.white, // Cor do título da AppBar
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          // Botão para alternar entre modo claro e escuro
          IconButton(
            icon: Icon(
              _modoEscuro ? Icons.dark_mode : Icons.light_mode, 
              color: Colors.white
            ),
            onPressed: () {
              setState(() {
                // Alterna o valor do modo escuro
                _modoEscuro = !_modoEscuro;
              });
            },
          ),
        ],
      ),
      // Menu lateral (Drawer) com opções de navegação
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                "Menu",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Login"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/");
              },
            ),
            ListTile(
              leading: Icon(Icons.task),
              title: Text("Adicionar Tarefas"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/tarefas");
              },
            ),
          ],
        ),
      ),
      // Corpo da tela com um GridView para mostrar as tarefas
      body: Padding(
        padding: EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2, // Definindo o número de colunas no grid
          crossAxisSpacing: 10, // Espaçamento horizontal entre os itens
          mainAxisSpacing: 10, // Espaçamento vertical entre os itens
          children: [
            // Adiciona um GridItem para cada lista de tarefas
            _buildGridItem("Pendentes", _pendentes.length, Colors.red, textoPrincipal),
            _buildGridItem("Concluídas", _concluidas.length, Colors.green, textoPrincipal),
            _buildGridItem("Em Andamento", 3, Colors.orange, textoPrincipal),
            _buildGridItem("Atrasadas", 2, Colors.purple, textoPrincipal),
            _buildGridItem("Canceladas", 1, Colors.grey, textoPrincipal),
            _buildGridItem("Revisão", 4, Colors.blueGrey, textoPrincipal),
          ],
        ),
      ),
    );
  }

  // Função auxiliar para construir cada item do grid
  Widget _buildGridItem(String title, int count, Color color, Color texto) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color, // Cor do fundo do item
        borderRadius: BorderRadius.circular(20), // Bordas arredondadas
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white, // Cor do título sempre branco
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "$count", // Exibe o número de tarefas
            style: TextStyle(
              color: Colors.white, // Cor do número sempre branco
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
