import 'package:biblioteca_app/controllers/usuario_controller.dart';
import 'package:biblioteca_app/models/usuario.dart';
import 'package:biblioteca_app/views/usuario/lista_usuarios.dart';
import 'package:flutter/material.dart';

class FormUsuarios extends StatefulWidget {
  final Usuario? user;
  const FormUsuarios({super.key, this.user});

  @override
  State<FormUsuarios> createState() => _FormUsuariosState();
}

class _FormUsuariosState extends State<FormUsuarios> {
  final _formKey = GlobalKey<FormState>();
  final _controller = UsuarioController();
  final _nomeField = TextEditingController();
  final _emailField = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _nomeField.text = widget.user!.nome;
      _emailField.text = widget.user!.email;
    }
  }

  void _save() async{
    if(_formKey.currentState!.validate()){
      final user = Usuario(
        id: DateTime.now().millisecond.toString(), //criar um ID 
        nome: _nomeField.text.trim(), 
        email: _emailField.text.trim());
      try {
        await _controller.create(user);
        //mensagem de criação com sucesso
      } catch (e) {
        //tratar erro
      }
      Navigator.pop(context);
      Navigator.pushReplacement(context, 
      MaterialPageRoute(builder: (context)=> ListaUsuarios()));
    }
  }

  void _update() async {
    if (_formKey.currentState!.validate()) {
      final user = Usuario(
        id: widget.user?.id!,
        nome: _nomeField.text.trim(),
        email: _emailField.text.trim(),
      );
      try {
        await _controller.update(user);
      } catch (e) {

      }
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ListaUsuarios()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 5, 102, 180),
        title: Text(
          widget.user == null ? "Novo Usuário" : "Editar Usuário",
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
                controller: _nomeField,
                decoration: InputDecoration(
                  labelText: "Nome",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Informe o Nome" : null,
              ),
              TextFormField(
                controller: _emailField,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Informe o Email" : null,
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: widget.user == null ? _save : _update, 
                child: Text(widget.user == null ? "Criar Usuário" : "Atualizar Usuário")
                ),
            ],
          ),
        ),
      ),
    );
  }
}
