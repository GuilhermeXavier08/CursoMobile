import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelaCadastro extends StatelessWidget {
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();
  TextEditingController _confirmacaoSenhaController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tela Cadastro"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                labelText: "Nome",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
              ),
            ),
            TextField(
              controller: _senhaController,
              decoration: InputDecoration(
                labelText: "Senha",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
              obscureText: true,
            ),
            TextField(
              controller: _confirmacaoSenhaController,
              decoration: InputDecoration(
                labelText: "Confirmar senha",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
              ),
              obscureText: true,
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () => _cadastrarUsuario(context), 
              child: Text("Cadastrar"))
          ],
        ),
      ),
    );
  }
  
  _cadastrarUsuario(BuildContext context) async{
    String _nome = _nomeController.text.trim();
    String _senha = _senhaController.text.trim();
    String _confirmacaoSenha = _confirmacaoSenhaController.text.trim();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String nomeExistente = _prefs.getString(_nome) ?? "";
    if (_nome.isEmpty||_senha.isEmpty||_confirmacaoSenha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Preencha todos os campos!")));
    }else if(nomeExistente.isNotEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Usuário já cadastrado!")));
    }else if(_senha != _confirmacaoSenha){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("A senha deve ser igual a cadastrada!")));
    }else{
      _prefs.setString(_nome, _senha);
      Navigator.pushNamed(context, "/");
    }
  }
}