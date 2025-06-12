import 'package:flutter/material.dart';
import 'package:sa_diario_viagens/controllers/viagem_controller.dart';
import 'package:sa_diario_viagens/models/viagem_model.dart';
import 'package:sa_diario_viagens/view/cadastro_viagem.dart';
import 'package:sa_diario_viagens/view/detalhe_viagem.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ViagemController _controllerViagem = ViagemController();

  List<Viagem> _viagens = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados() async {
    setState(() {
      _isLoading = true;
    });
    _viagens = [];
    try {
      _viagens = await _controllerViagem.readPets();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao carregar os dados: $e")));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Minhas Viagens")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: _viagens.length,
                itemBuilder: (context, index) {
                  final viagem = _viagens[index];
                  return ListTile(
                    title: Text("${viagem.titulo} - ${viagem.destino}"),
                    subtitle: Text(
                      "De ${viagem.data_inicio.day}/${viagem.data_inicio.month}/${viagem.data_inicio.year} até ${viagem.data_fim.day}/${viagem.data_fim.month}/${viagem.data_fim.year}",
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetalheViagemScreen(viagemId: viagem.id!),
                      ),
                    ),
                    onLongPress: () => _deleteViagem(viagem.id!),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CadastroViagem()),
        ),
        tooltip: "Planejar Nova Viagem",
        child: Icon(Icons.add),
      ),
    );
  }

  void _deleteViagem(int id) async {
    try {
      await _controllerViagem.deleteViagem(id);
      _carregarDados();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Viagem deletada com sucesso")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Exception: $e")));
    }
  }
}
