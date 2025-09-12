import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TarefasView extends StatefulWidget {
  const TarefasView({super.key});

  @override
  State<TarefasView> createState() => _TarefasViewState();
}

class _TarefasViewState extends State<TarefasView> {
  final _db = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;
  final _tarefasField = TextEditingController();

  void _addTarefa() async {
    if (_tarefasField.text.trim().isEmpty) {
      return;
    }
    try {
      await _db
          .collection("usuarios")
          .doc(_user!.uid)
          .collection("tarefas")
          .add({
            "titulo": _tarefasField.text.trim(),
            "concluida": false,
            "dataCriacao": Timestamp.now(),
          });
          _tarefasField.clear();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao Add Tarefas: $e")));
    }
  }

  void _atualizarTarefa(String tarefaId, bool concluida) async {
    try {
      await _db
          .collection("usuarios")
          .doc(_user!.uid)
          .collection("tarefas")
          .doc(tarefaId)
          .update({"concluida": !concluida});
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao atualizar tarefa: $e")));
    }
  }

  void _deletarTarefa(String tarefaId) async {
    try {
      await _db
          .collection("usuarios")
          .doc(_user!.uid)
          .collection("tarefas")
          .doc(tarefaId)
          .delete();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao deletar tarefa: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 22, 121, 202),
        title: Text("Minhas Tarefas", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: FirebaseAuth.instance.signOut,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
                labelText: "Nova Tarefa",
                suffix: IconButton(
                  onPressed: _addTarefa,
                  icon: Icon(Icons.add),
                ),
                labelStyle: TextStyle(fontSize: 25),
              ),
              controller: _tarefasField,
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _db
                    .collection("usuarios")
                    .doc(_user?.uid)
                    .collection("tarefas")
                    .orderBy("dataCriacao", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("Nenhuma tarefa encontrada", style: TextStyle(fontSize: 20),));
                  }
                  final tarefas = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: tarefas.length,
                    itemBuilder: (context, index) {
                      final tarefa = tarefas[index];
                      final tarefaMap = tarefa.data() as Map<String, dynamic>;
                      bool concluida = tarefaMap["concluida"] ?? false;
                      return ListTile(
                        title: Text(tarefaMap["titulo"]),
                        leading: Checkbox(
                          value: concluida,
                          onChanged: (value) {
                            _atualizarTarefa(tarefa.id, concluida);
                          },
                        ),
                        trailing: IconButton(
                          onPressed: () => _deletarTarefa(tarefa.id),
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                      );
                    },
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
