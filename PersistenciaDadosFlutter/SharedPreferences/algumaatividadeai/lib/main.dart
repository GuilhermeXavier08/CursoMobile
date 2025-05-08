import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp());
}

class Perfil extends StatefulWidget {

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _corController = TextEditingController();
  TextEditingController _idadeController = TextEditingController();
  String _nome = "";
  String _cor = "";
  String _idade = "";
  
  @override
  void initState(){
    super.initState();
  }
  _carregarPerfil() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      _nome = _prefs.getString("nome") ?? "";
      _cor = _prefs.getString("cor") ?? "";
      _idade = _prefs.getString("idade") ?? "";
    });
  }
  _mostrarPerfil(){
    Text(_cor + _nome + _idade);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                labelText: "Nome",
                border: UnderlineInputBorder(),
              ),
            ),
            TextField(
              controller: _idadeController,
              decoration: InputDecoration(
                labelText: "Idade",
                border: UnderlineInputBorder(),
              ),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _cor = "Azul";
                  }, 
                  child: Text("Azul")),
                ElevatedButton(
                  onPressed: () {
                    _cor = "Vermelho";
                  }, 
                  child: Text("Vermelho")),
                ElevatedButton(
                  onPressed: () {
                    _cor = "Amarelo";
                  }, 
                  child: Text("Amarelo")),
                ElevatedButton(
                  onPressed: () {
                    _cor = "Verde";
                  }, 
                  child: Text("Verde")),       
              ],
            ),
            ElevatedButton(
              onPressed: _carregarPerfil(), 
              child: Text("Salvar Dados")
              ),
            Text(_mostrarPerfil())
          ],
        ),
        ),
    );
  }
}