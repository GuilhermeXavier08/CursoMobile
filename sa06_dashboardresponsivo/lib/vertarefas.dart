import 'package:flutter/material.dart';

class VerTarefas extends StatefulWidget {
  @override
  _VerTarefasState createState() => _VerTarefasState();
}

class _VerTarefasState extends State<VerTarefas> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _pendentes = [
    "Arrumar o Quarto",
    "Passear com o Cachorro",
    "Lavar a Louça",
    "Varrer a Casa",
    "Aspirar o Pó",
    "Tirar o Lixo para fora"
  ];

  final List<String> _concluidas = [
    "Dar Banho no Cachorro",
    "Fazer Dever de Casa",
    "Estender a Roupa no Varal",
    "Regar as Plantas",
    "Fazer Almoço",
    "Pagar as Contas"
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "VER TAREFAS",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.white,
          tabs: [
            Tab(text: "Pendentes"),
            Tab(text: "Concluídas"),
          ],
        ),
      ),
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
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                _buildGridItem("Pendentes", _pendentes.length, Colors.red),
                _buildGridItem("Concluídas", _concluidas.length, Colors.green),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTarefaList(_pendentes, Colors.grey),
                _buildTarefaList(_concluidas, Colors.blue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(String title, int count, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "$count",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTarefaList(List<String> tarefas, Color color) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: tarefas.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              tarefas[index],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color == Colors.blue ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }
}