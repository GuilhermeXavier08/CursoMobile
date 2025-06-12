import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sa_diario_viagens/view/detalhe_viagem.dart';
import '../controllers/entrada_diaria_controller.dart';
import '../models/entrada_diaria_model.dart';

class CadastroEntradaDiariaScreen extends StatefulWidget {
  final int viagemId;
  const CadastroEntradaDiariaScreen({super.key, required this.viagemId});

  @override
  State<CadastroEntradaDiariaScreen> createState() => _CadastroEntradaDiariaScreenState();
}

class _CadastroEntradaDiariaScreenState extends State<CadastroEntradaDiariaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _entradaController = EntradaDiariaController();

  late String _texto;
  DateTime _dataSelecionada = DateTime.now();
  String? _fotoPath;

  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _dataSelecionada) {
      setState(() {
        _dataSelecionada = picked;
      });
    }
  }

  Widget _fotoInput() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Caminho da Foto (opcional)",
        border: OutlineInputBorder(),
      ),
      onSaved: (value) => _fotoPath = value!.isEmpty ? null : value,
    );
  }

  _salvarEntrada() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final novaEntrada = EntradaDiaria(
        viagemId: widget.viagemId,
        data: _dataSelecionada,
        texto: _texto,
        fotoPath: _fotoPath,
      );
      try {
        await _entradaController.createEntrada(novaEntrada);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Entrada diária registrada com sucesso!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DetalheViagemScreen(viagemId: widget.viagemId),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Exception: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataFormatada = DateFormat("dd/MM/yyyy");
    return Scaffold(
      appBar: AppBar(
        title: Text("Nova Entrada Diária"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(
                children: [
                  Text("Data: ${dataFormatada.format(_dataSelecionada)}"),
                  TextButton(
                    onPressed: () => _selecionarData(context),
                    child: Text("Selecionar Data"),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Texto do Diário",
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) => value!.isEmpty ? "Campo não preenchido" : null,
                onSaved: (value) => _texto = value!,
              ),
              SizedBox(height: 10),
              _fotoInput(),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _salvarEntrada,
                child: Text("Salvar Entrada"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}