import 'package:flutter/material.dart';
import 'dart:io';
import 'package:sa_diario_viagens/controllers/entrada_diaria_controller.dart';
import 'package:sa_diario_viagens/controllers/viagem_controller.dart';
import 'package:sa_diario_viagens/models/entrada_diaria_model.dart';
import 'package:sa_diario_viagens/models/viagem_model.dart';
import 'package:sa_diario_viagens/view/cadastro_entrada.dart';


class DetalheViagemScreen extends StatefulWidget {
  final int viagemId;
  const DetalheViagemScreen({super.key, required this.viagemId});

  @override
  State<StatefulWidget> createState() => _DetalheViagemScreenState();
}

class _DetalheViagemScreenState extends State<DetalheViagemScreen> {
  final ViagemController _viagemController = ViagemController();
  final EntradaDiariaController _entradaController = EntradaDiariaController();
  bool _isLoading = true;
  Viagem? _viagem;
  List<EntradaDiaria> _entradas = [];

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  _carregarDados() async {
    setState(() {
      _isLoading = true;
    });
    try {
      _viagem = await _viagemController.readViagemById(widget.viagemId);
      _entradas = await _entradaController.readEntradaForViagem(widget.viagemId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Exception: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detalhe da Viagem")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _viagem == null
              ? Center(child: Text("Erro ao carregar a Viagem"))
              : Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Título: ${_viagem!.titulo}", style: TextStyle(fontSize: 20)),
                      Text("Destino: ${_viagem!.destino}", style: TextStyle(fontSize: 20)),
                      Text(
                        "Período: ${_viagem!.data_inicio.day}/${_viagem!.data_inicio.month}/${_viagem!.data_inicio.year} até ${_viagem!.data_fim.day}/${_viagem!.data_fim.month}/${_viagem!.data_fim.year}",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text("Descrição: ${_viagem!.descricao}", style: TextStyle(fontSize: 18)),
                      Divider(),
                      Text("Entradas Diárias:", style: TextStyle(fontSize: 20)),
                      _entradas.isEmpty
                          ? Center(child: Text("Nenhuma entrada diária registrada"))
                          : Expanded(
                              child: ListView.builder(
                                itemCount: _entradas.length,
                                itemBuilder: (context, index) {
                                  final entrada = _entradas[index];
                                  return Card(
                                    margin: EdgeInsets.symmetric(vertical: 4),
                                    child: ListTile(
                                      title: Text(
                                        "${entrada.data.day}/${entrada.data.month}/${entrada.data.year}",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(entrada.texto),
                                      trailing: IconButton(
                                        onPressed: () => _deleteEntrada(entrada.id!),
                                        icon: Icon(Icons.delete, color: Colors.red),
                                      ),
                                      leading: entrada.fotoPath != null
                                          ? Image.file(
                                              File(entrada.fotoPath!),
                                              width: 48,
                                              height: 48,
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                  );
                                },
                              ),
                            ),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CadastroEntradaDiariaScreen(viagemId: widget.viagemId),
          ),
        ).then((_) => _carregarDados()),
        tooltip: "Adicionar Entrada Diária",
        child: Icon(Icons.add),
      ),
    );
  }

  void _deleteEntrada(int entradaId) async {
    try {
      await _entradaController.deleteEntrada(entradaId);
      _carregarDados();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Entrada deletada com sucesso")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Exception: $e")),
      );
    }
  }
}