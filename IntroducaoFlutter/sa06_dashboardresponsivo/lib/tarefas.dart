import 'package:flutter/material.dart';

// Widget principal com estado
class ListaTarefas extends StatefulWidget {
  @override
  _ListaTarefasState createState() => _ListaTarefasState();
}

class _ListaTarefasState extends State<ListaTarefas> with SingleTickerProviderStateMixin {
  // Controlador do campo de texto
  final TextEditingController _tarefaController = TextEditingController();

  // Lista de tarefas que o usuário adiciona
  final List<Map<String, dynamic>> _tarefasAdicionadas = [];

  // Controlador das abas (pendentes/concluídas)
  late TabController _tabController;

  // Controle do modo escuro
  bool _modoEscuro = false;

  // Lista de tarefas fixas pendentes
  final List<String> _pendentesFixas = [
    "Arrumar o Quarto",
    "Passear com o Cachorro",
    "Lavar a Louça",
    "Varrer a Casa",
    "Aspirar o Pó",
    "Tirar o Lixo para fora"
  ];

  // Lista de tarefas fixas concluídas
  final List<String> _concluidasFixas = [
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
    // Inicializa as abas
    _tabController = TabController(length: 2, vsync: this);
  }

  // Adiciona uma nova tarefa à lista personalizada
  void _adicionarTarefa() {
    if (_tarefaController.text.trim().isNotEmpty) {
      setState(() {
        _tarefasAdicionadas.add({"titulo": _tarefaController.text, "concluida": false});
        _tarefaController.clear(); // Limpa o campo de texto
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define as cores com base no modo claro/escuro
    Color textoPrincipal = _modoEscuro ? Colors.white : Colors.black;
    Color fundo = _modoEscuro ? const Color(0xFF323232) : Colors.white;

    return Scaffold(
      backgroundColor: fundo,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "ADICIONAR TAREFA",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          // Botão para alternar modo escuro/claro
          IconButton(
            icon: Icon(_modoEscuro ? Icons.dark_mode : Icons.light_mode, color: Colors.white),
            onPressed: () {
              setState(() {
                _modoEscuro = !_modoEscuro;
              });
            },
          ),
        ],
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
              title: Text("Informações"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/vertarefas");
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Formulário para adicionar nova tarefa
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  "NOVA TAREFA",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: textoPrincipal),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _tarefaController,
                  style: TextStyle(color: textoPrincipal),
                  decoration: InputDecoration(
                    labelText: "Digite uma tarefa",
                    labelStyle: TextStyle(color: textoPrincipal),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textoPrincipal),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textoPrincipal),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  ),
                  onPressed: _adicionarTarefa,
                  child: Text(
                    "ADICIONAR",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Título das tarefas fixas
          Text(
            "TAREFAS FIXAS",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textoPrincipal),
          ),
          // Abas com listas fixas
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildListaFixa(_pendentesFixas, Colors.red, textoPrincipal),
                _buildListaFixa(_concluidasFixas, Colors.green, textoPrincipal),
              ],
            ),
          ),
          Divider(thickness: 2, color: textoPrincipal),
          // Título das tarefas personalizadas
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "SUAS TAREFAS",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textoPrincipal),
            ),
          ),
          // Lista de tarefas adicionadas pelo usuário
          Expanded(
            child: ListView.builder(
              itemCount: _tarefasAdicionadas.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _tarefasAdicionadas[index]["titulo"],
                    style: TextStyle(
                      color: textoPrincipal,
                      decoration: _tarefasAdicionadas[index]["concluida"]
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  leading: Checkbox(
                    value: _tarefasAdicionadas[index]["concluida"],
                    onChanged: (bool? valor) {
                      setState(() {
                        _tarefasAdicionadas[index]["concluida"] = valor!;
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Função para criar a lista de tarefas fixas
  Widget _buildListaFixa(List<String> tarefas, Color color, Color texto) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: tarefas.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            tarefas[index],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: texto,
            ),
          ),
        );
      },
    );
  }
}
