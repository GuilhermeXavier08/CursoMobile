import 'package:flutter/material.dart';

class ListaTarefas extends StatefulWidget {
  @override
  _ListaTarefasState createState() => _ListaTarefasState();
}

class _ListaTarefasState extends State<ListaTarefas> {
  final TextEditingController _tarefaController = TextEditingController();
  final List<Map<String, dynamic>> _tarefas = [];

  void _adicionarTarefa() {
    if (_tarefaController.text.trim().isNotEmpty) {
      setState(() {
        _tarefas.add({"titulo": _tarefaController.text, "concluida": false});
        _tarefaController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              title: Text("Ver Tarefas"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/vertarefas");
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            Text(
              "NOVA TAREFA",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _tarefaController,
              decoration: InputDecoration(
                labelText: "Digite uma tarefa",
                border: UnderlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),
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
            SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/vertarefas");
              },
              child: Text(
                "Ver Tarefas",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 30),
            Text("SUAS TAREFAS", style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),),
            Expanded(
            child: ListView.builder(
              itemCount: _tarefas.length,
              itemBuilder:
                  (context, index) => ListTile(
                    title: Text(
                      _tarefas[index]["titulo"],
                      style: TextStyle(
                        decoration:
                            _tarefas[index]["concluida"]
                                ? TextDecoration.lineThrough
                                : null,
                      ),
                    ),
                    leading: Checkbox(
                      value: _tarefas[index]["concluida"],
                      onChanged: (bool? valor) {
                        setState(() {
                          _tarefas[index]["concluida"] = valor!;
                        });
                      },
                    ),
                  ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}