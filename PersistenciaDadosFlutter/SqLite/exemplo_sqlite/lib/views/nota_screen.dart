import 'package:exemplo_sqlite/controllers/notas_controller.dart';
import 'package:exemplo_sqlite/models/notas_model.dart';
import 'package:flutter/material.dart';

class NotaScreen extends StatefulWidget{
  @override
  State<NotaScreen> createState() => _NotaScreenState();
}

class _NotaScreenState extends State<NotaScreen>{
  final NotasController _notasController = NotasController();

  List<Nota> _notes = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadNotas();
  }
  Future<void> _loadNotas() async{
    setState(() {
      _isLoading = true;
    });
    try{
      _notes = await _notasController.fetchNotas();
    }catch(e){
      print("Erro ao carregar!: $e");
      _notes = [];
    }finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addNota() async{
    Nota novaNota = Nota(titulo: "Nota ${DateTime.now()}", conteudo: "Conteúdo da nota");
    await _notasController.addNota(novaNota);
    _loadNotas();
  }

  Future<void> _deleteNota(int id) async{
    final delete = await _notasController.deleteNota(id);
    _loadNotas();
  }

  Future<void> _updateNota(Nota nota) async{
    Nota notaAtualizada = Nota(id: nota.id, titulo: "${nota.titulo} (editado)", conteudo: nota.conteudo);
    final update = await _notasController.updateNota(notaAtualizada);
    _loadNotas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas Notas"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: _isLoading ? Center(
        child: CircularProgressIndicator()) : ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final nota = _notes[index];
          return ListTile(
            title: Text(nota.titulo),
            subtitle: Text(nota.conteudo),
            onTap: () => _updateNota(nota),
            onLongPress: () => _deleteNota(nota.id!),
          );
        },
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNota,
        tooltip: "Adicionar Nota",
        child: Icon(Icons.add),
        )
  
  );
  }
}