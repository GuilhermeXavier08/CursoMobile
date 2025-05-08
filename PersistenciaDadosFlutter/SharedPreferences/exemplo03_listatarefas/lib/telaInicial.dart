import 'package:exemplo03_listatarefas/telaCadastro.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Telainicial extends StatefulWidget {
  @override
  State<Telainicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<Telainicial> {
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();

  String _nome = "";
  String _senha = "";
  bool _darkMode = false;
  bool _logado = false;

  @override
  void initState() {
    super.initState();
    _carregarPreferencias();
    if (_logado) {
      Navigator.pushNamed(context, "/tarefas");
    }
  }

  void _carregarPreferencias() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      _nome = _prefs.getString("nome") ?? "";
      _senha = _prefs.getString(_nome) ?? "";
      _darkMode = _prefs.getBool("darkMode") ?? false;
      _logado = _prefs.getBool("logado") ?? false;
    });
  }

  _trocarTema() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = !_darkMode;
      _prefs.setBool("darkMode", _darkMode);
    });
  }

  _logar() async {
    _nome = _nomeController.text.trim();
    _senha = _senhaController.text.trim();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (_nome.isEmpty || _senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Preencha todos os campos!")));
    }else if(_prefs.getString(_nome) == _senha){
      _prefs.setString("nome", _nome);
      _prefs.setBool("logado", true);
      _nomeController.clear();
      _senhaController.clear();
      Navigator.pushNamed(context, "/tarefas");
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Nome e/ou Senha Incorreta")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedTheme(
      data: _darkMode ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Bem-Vindo ${_nome == "" ? "Visitante" : _nome}"),
          actions: [
            IconButton(
              onPressed: _trocarTema,
              icon: Icon(_darkMode ? Icons.light_mode : Icons.dark_mode),
            ),
          ],
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: Padding(padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Fazer Login", style: TextStyle(fontSize: 20),),
            SizedBox(height: 20,),
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
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              obscureText: true,
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: _logar, 
              child: Text("Logar")
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, "/cadastro"), 
              child: Text("Cadastrar")),
            
          ],
        ),
        ),
      ),
    );
  }
}
