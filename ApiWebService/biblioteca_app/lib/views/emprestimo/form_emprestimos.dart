import 'package:biblioteca_app/controllers/Livro_controller.dart';
import 'package:biblioteca_app/controllers/emprestimo_controller.dart';
import 'package:biblioteca_app/controllers/usuario_controller.dart';
import 'package:biblioteca_app/models/emprestimo.dart';
import 'package:biblioteca_app/views/home_view.dart';
import 'package:flutter/material.dart';

class FormEmprestimos extends StatefulWidget {
  final Emprestimo? emprestimo;
  const FormEmprestimos({super.key, this.emprestimo});

  @override
  State<FormEmprestimos> createState() => _FormEmprestimosState();
}

class _FormEmprestimosState extends State<FormEmprestimos> {
  final _formKey = GlobalKey<FormState>();
  final _controller = EmprestimoController();
  final _usuarioController = UsuarioController();
  final _livroController = LivroController();

  final _usuarioField = TextEditingController();
  final _livroField = TextEditingController();
  DateTime _dataEmprestimo = DateTime.now();
  DateTime _dataDevolucao = DateTime.now().add(Duration(days: 7));
  bool _devolvido = false;

  DateTime _hoje() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  @override
  void initState() {
    super.initState();
    if (widget.emprestimo != null) {
      _usuarioField.text = widget.emprestimo!.usuario_id;
      _livroField.text = widget.emprestimo!.livro_id;
      _dataEmprestimo = widget.emprestimo!.data_emprestimo;
      _dataDevolucao = widget.emprestimo!.data_devolucao;
      _devolvido = widget.emprestimo!.devolvido;
    } else {
      _dataEmprestimo = _hoje();
      _dataDevolucao = _hoje().add(Duration(days: 7));
    }
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      if (_dataEmprestimo.isAfter(_dataDevolucao) ||
          _dataEmprestimo.isAtSameMomentAs(_dataDevolucao)) {
        _showDialog("A data de empréstimo deve ser menor que a data de devolução!");
        return;
      }

      final usuarioId = _usuarioField.text.trim();
      final livroId = _livroField.text.trim();

      try {
        final usuario = await _usuarioController.fetchOne(usuarioId);
        if (usuario == null) {
          _showDialog("Usuário com ID $usuarioId não encontrado!");
          return;
        }

        final livro = await _livroController.fetchOne(livroId);
        if (livro == null) {
          _showDialog("Livro com ID $livroId não encontrado!");
          return;
        }

        final emprestimo = Emprestimo(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          usuario_id: usuarioId,
          livro_id: livroId,
          data_emprestimo: _dataEmprestimo,
          data_devolucao: _dataDevolucao,
          devolvido: _devolvido,
        );

        await _controller.create(emprestimo);

        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeView()),
        );
      } catch (e) {
        _showDialog("Erro inesperado: $e");
      }
    }
  }

  void _update() async {
    if (_formKey.currentState!.validate()) {
      if (_dataEmprestimo.isAfter(_dataDevolucao) ||
          _dataEmprestimo.isAtSameMomentAs(_dataDevolucao)) {
        _showDialog("A data de empréstimo deve ser menor que a data de devolução!");
        return;
      }

      final usuarioId = _usuarioField.text.trim();
      final livroId = _livroField.text.trim();

      try {
        final usuario = await _usuarioController.fetchOne(usuarioId);
        if (usuario == null) {
          _showDialog("Usuário com ID $usuarioId não encontrado!");
          return;
        }

        final livro = await _livroController.fetchOne(livroId);
        if (livro == null) {
          _showDialog("Livro com ID $livroId não encontrado!");
          return;
        }

        final emprestimo = Emprestimo(
          id: widget.emprestimo?.id,
          usuario_id: usuarioId,
          livro_id: livroId,
          data_emprestimo: _dataEmprestimo,
          data_devolucao: _dataDevolucao,
          devolvido: _devolvido,
        );

        await _controller.updated(emprestimo);

        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeView()),
        );
      } catch (e) {
        _showDialog("Erro ao atualizar empréstimo!");
      }
    }
  }

  void _showDialog(String msg) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Aviso"),
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            )
          ],
        );
      },
    );
  }

  Future<void> _selecionarDataEmprestimo() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _dataEmprestimo,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (data != null) {
      setState(() => _dataEmprestimo = DateTime(data.year, data.month, data.day));
    }
  }

  Future<void> _selecionarDataDevolucao() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _dataDevolucao,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (data != null) {
      setState(() => _dataDevolucao = DateTime(data.year, data.month, data.day));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 5, 102, 180),
        title: Text(
          widget.emprestimo == null ? "Novo Empréstimo" : "Editar Empréstimo",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usuarioField,
                decoration: InputDecoration(
                  labelText: "ID Usuário",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Informe o ID do usuário" : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _livroField,
                decoration: InputDecoration(
                  labelText: "ID Livro",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Informe o ID do livro" : null,
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Data Empréstimo: ${_dataEmprestimo.toLocal().toString().split(' ')[0]}"),
                  TextButton(
                    onPressed: _selecionarDataEmprestimo,
                    child: Text("Selecionar"),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Data Devolução: ${_dataDevolucao.toLocal().toString().split(' ')[0]}"),
                  TextButton(
                    onPressed: _selecionarDataDevolucao,
                    child: Text("Selecionar"),
                  )
                ],
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Devolvido"),
                  Switch(
                    value: _devolvido,
                    onChanged: (value) {
                      setState(() {
                        _devolvido = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: widget.emprestimo == null ? _save : _update,
                child: Text(widget.emprestimo == null
                    ? "Criar Empréstimo"
                    : "Atualizar Empréstimo"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
