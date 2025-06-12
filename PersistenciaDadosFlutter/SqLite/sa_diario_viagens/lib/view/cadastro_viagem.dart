import 'package:flutter/material.dart';
import 'package:sa_diario_viagens/controllers/viagem_controller.dart';
import 'package:sa_diario_viagens/models/viagem_model.dart';
import 'package:sa_diario_viagens/view/home_screen.dart';

class CadastroViagem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CadastroViagemState();
  }
}

class _CadastroViagemState extends State<CadastroViagem> {
  final _formKey = GlobalKey<FormState>();
  final _controllerViagem = ViagemController();

  late String _titulo;
  late String _destino;
  late String _descricao;
  DateTime? _dataInicio;
  DateTime? _dataFim;

  _salvarViagem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newViagem = Viagem(
        titulo: _titulo,
        destino: _destino,
        descricao: _descricao,
        data_inicio: _dataInicio ?? DateTime.now(),
        data_fim: _dataFim ?? DateTime.now(),
      );

      await _controllerViagem.createViagem(newViagem);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  Future<void> _selecionarDataInicio(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dataInicio = picked;
        if (_dataFim != null && _dataFim!.isBefore(picked)) {
          _dataFim = null;
        }
      });
    }
  }

  Future<void> _selecionarDataFim(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dataInicio ?? DateTime.now(),
      firstDate: _dataInicio ?? DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dataFim = picked;
      });
    }
  }

  String _formatarData(DateTime? data) {
    if (data == null) return "";
    return "${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastro de Viagem")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Título da Viagem"),
                validator: (value) => value!.isEmpty ? "Campo não preenchido" : null,
                onSaved: (value) => _titulo = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Destino"),
                validator: (value) => value!.isEmpty ? "Campo não preenchido" : null,
                onSaved: (value) => _destino = value!,
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _selecionarDataInicio(context),
                      child: Text(
                        _dataInicio == null
                            ? "Selecionar Data Início"
                            : "Início: ${_formatarData(_dataInicio)}",
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _dataInicio == null ? null : () => _selecionarDataFim(context),
                      child: Text(
                        _dataFim == null
                            ? "Selecionar Data Fim"
                            : "Fim: ${_formatarData(_dataFim)}",
                      ),
                    ),
                  ),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Descrição"),
                validator: (value) => value!.isEmpty ? "Campo não preenchido" : null,
                onSaved: (value) => _descricao = value!,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _salvarViagem,
                child: Text("Cadastrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
