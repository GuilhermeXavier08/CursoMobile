import 'package:flutter/material.dart';
import 'package:json_web_service_clima/controllers/clima_controller.dart';
import 'package:json_web_service_clima/models/clima_model.dart';

class ClimaView extends StatefulWidget {
  const ClimaView({super.key});

  @override
  State<ClimaView> createState() => _ClimaViewState();
}

class _ClimaViewState extends State<ClimaView> {
  final TextEditingController _cidadeController = TextEditingController();
  final ClimaController _climaController = ClimaController();
  Clima? _clima;
  String? _erro;

  void buscar() async {
    final cidade = _cidadeController.text.trim();
    final resultado = await _climaController.getClima(cidade);
    setState(() {
      if (resultado != null) {
        _clima = resultado;
        _erro = null;
        _cidadeController.clear();
      } else {
        _clima = null;
        _erro = "Cidade não encontrada";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text("Clima em tempo real"),
      ),
      body: Padding(padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _cidadeController,
              decoration: InputDecoration(
                labelText: "Digite uma cidade",
              ),
            ),
            ElevatedButton(onPressed: buscar, child: Text("Buscar clima")),
            Divider(),
            if(_clima != null) ... [
              Text("Cidade: ${_clima!.nome}"),
              Text("Temperatura: ${_clima!.temperatura}°C"),
              Text("Descrição: ${_clima!.descricao}"),
            ] else if(_erro != null) ... [
              Text(_erro!),
            ] else ... [
              Text("Procure uma cidade")
            ]
          ],
        ),
      )
    );
  }
}
