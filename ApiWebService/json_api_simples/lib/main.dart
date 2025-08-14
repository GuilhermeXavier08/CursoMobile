import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(home: TarefasPage(), debugShowCheckedModeBanner: false));
}

class TarefasPage extends StatefulWidget {
  const TarefasPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _TarefasPageState();
  }
}

class _TarefasPageState extends State<TarefasPage> {
  //atributos
  //lista de tarefas<map>
  List<Map<String, dynamic>> _tarefas = [];
  //controlador para o textfield
  final TextEditingController _tarefaController = TextEditingController();
  //endereco da api
  final String baseUrl = "http://10.109.197.4:3014/tarefas";

  //metodos
  @override
  void initState() {
    super.initState();
    _carregarTarefas();
  }

  void _carregarTarefas() async {
    try {
      //fazer conexao via http(biblioteca http)
      final response = await http.get(
        Uri.parse(baseUrl),
      ); //converte str - para endereco url
      if (response.statusCode == 200) {
        List<dynamic> dados = json.decode(response.body);
        setState(() {
          _tarefas = dados
              .map((item) => Map<String, dynamic>.from(item))
              .toList(); // jeito mais correto
          // _tarefas = dados.cast<Map<String,dynamic>>(); // jeito mais rapido
          // _tarefas = List<Map<String,dynamic>>.from(dados); // jeito mais "direto"
        });
      }
    } catch (e) {
      print("Erro ao carregar API: ${e}");
    }
  }

  void _adicionarTarefa(String titulo) async {
    try {
      //cria um objeto -> tarefa
      final tarefa = {"titulo": titulo, "concluida": false};
      //faz post http
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-type": "application/json"},
        body: json.encode(tarefa), //converte de dart -> json
      );
      //verifica se deu certo
      if (response.statusCode == 201) {
        setState(() {
          _tarefaController.clear();
          _carregarTarefas();
        });
      }
    } catch (e) {
      print("Erro ao adicionar tarefa ${e}");
    }
  }

  void _removerTarefa(String id) async {
    try {
      //solicitação http -> delete (url + id)
      final response = await http.delete(Uri.parse("$baseUrl/$id"));
      if (response.statusCode == 200) {
        setState(() {
          _carregarTarefas();
        });
      }
    } catch (e) {
      print("Erro ao deletar Tarefa $e");
    }
  }
  void _atualizarTarefa(bool concluida, String id) async {
    try {
      final response = await http.patch(Uri.parse("$baseUrl/$concluida/$id"));
      concluida!;
      if (response.statusCode == 204) {  
        setState(() {
          _carregarTarefas();
        });
      }
    } catch (e) {
      print("Erro ao atualizar Tarefa $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text("Tarefas via API"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _tarefaController,
              decoration: InputDecoration(
                labelText: "Nova Tarefa",
                border: OutlineInputBorder(),
              ),
              onSubmitted: _adicionarTarefa,
            ),
            SizedBox(height: 10),
            Expanded(
              child: _tarefas.isEmpty
                  ? Center(child: Text("Nenhuma tarefa cadastrada"))
                  : ListView.builder(
                      itemCount: _tarefas.length,
                      itemBuilder: (context, index) {
                        final tarefa = _tarefas[index];
                        return ListTile(
                          //leading para criar um checkbox(atualizar)
                          title: Text(tarefa["titulo"]),
                          subtitle: Text(
                            tarefa["concluida"] ? "Concluída" : "Pendente",
                          ),
                          trailing: IconButton(
                            onPressed: () => _removerTarefa(tarefa["id"]),
                            icon: Icon(Icons.delete),
                          ),
                          onTap: () => _atualizarTarefa(tarefa["id, concluida"]),
                        );
                        
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
