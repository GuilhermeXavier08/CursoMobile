import 'package:biblioteca_app/controllers/Livro_controller.dart';
import 'package:biblioteca_app/models/livro.dart';
import 'package:biblioteca_app/views/home_view.dart';
import 'package:flutter/material.dart';

class FormLivros extends StatefulWidget {
  final Livro? book;
  const FormLivros({super.key, this.book});

  @override
  State<FormLivros> createState() => _FormLivrosState();
}

class _FormLivrosState extends State<FormLivros> {
  final _formKey = GlobalKey<FormState>();
  final _controller = LivroController();
  final _tituloField = TextEditingController();
  final _autorField = TextEditingController();
  bool _disponivel = true; // default

  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      _tituloField.text = widget.book!.titulo;
      _autorField.text = widget.book!.autor;
      _disponivel = widget.book!.disponivel;
    }
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      final book = Livro(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        titulo: _tituloField.text.trim(),
        autor: _autorField.text.trim(),
        disponivel: _disponivel,
      );
      try {
        await _controller.create(book);
      } catch (e) {}
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeView()),
      );
    }
  }

  void _update() async {
    final book = Livro(
      id: widget.book?.id!,
      titulo: widget.book!.titulo,
      autor: widget.book!.autor,
      disponivel: _disponivel,
    );
    try {
      await _controller.update(book);
    } catch (e) {}
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.book != null;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 5, 102, 180),
        title: Text(
          isEditing ? "Editar Disponibilidade" : "Novo Livro",
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
                controller: _tituloField,
                enabled: !isEditing, // desativa edição quando já existe
                decoration: InputDecoration(
                  labelText: "Título",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Informe o título" : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _autorField,
                enabled: !isEditing, // desativa edição quando já existe
                decoration: InputDecoration(
                  labelText: "Autor",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Informe o autor" : null,
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Disponível"),
                  Switch(
                    value: _disponivel,
                    onChanged: (value) {
                      setState(() {
                        _disponivel = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: isEditing ? _update : _save,
                child: Text(isEditing
                    ? "Atualizar Status"
                    : "Criar Livro"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
