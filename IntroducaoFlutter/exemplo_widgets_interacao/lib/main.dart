
import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(debugShowCheckedModeBanner: false,home: MyApp()));
}

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _formKey = GlobalKey<FormState>();
  String _nome = "";
  String _email = "";
  String _senha = "";
  String _genero = "";
  String _dataNascimento = "";
  double _experiencia = 0;
  bool _aceite = false;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de usuário"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(key: _formKey, 
          child: 
            Column(
              children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Digite seu nome",
                ),
                validator: (value) => value!.isEmpty ? "Campo obrigatório" : null, //Operador Ternário
                onSaved: (value) => _nome = value!,
              ),
              SizedBox(height: 20,),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Digite seu email",
                ),
                validator: (value) => value!.contains("@") ? null : "Digite um email válido",
                onSaved: (value) => _email = value!,
              ),
              SizedBox(height: 20,),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Digite sua senha",
                ),
                obscureText: true,
                validator: (value) => value!.length<6 ? "Digite uma senha de pelo menos 6 digitos" : null,
                onSaved: (value) => _senha = value!,
              ),
              SizedBox(height: 20,),
                  Text("Gênero: "),
                  DropdownButtonFormField(
                    items: ["Masculino","Feminino"].map((String genero)=>
                      DropdownMenuItem(value: genero,child:Text(genero) )).toList(), 
                    onChanged: (value){},
                    validator: (value) => value==null ? "Selecione um gênero" : null,
                    onSaved: (value) => _genero=value!,
                    ),
                SizedBox(height: 20,),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Digite sua data de nascimento",
                ),
                validator: (value) => value!.isEmpty ? "Informe a data de nascimento" : null,
                onSaved: (value) => _dataNascimento = value!,
              ),
              SizedBox(height: 20,),
              Slider(value: _experiencia, 
              min: 0,
              max: 30,
              divisions: 30,
              label: _experiencia.round().toString(),
              onChanged: (value) {
                setState(() {
                  _experiencia = value;
                });
              },
              ),
              SizedBox(height: 20,),
              CheckboxListTile(
                value: _aceite,
                title: Text("Aceito os Termos de Uso"),
                onChanged: (value) {
                  setState(() {
                    _aceite = value!;
                  });
                  
                }),
                ElevatedButton(
                onPressed: _enviarFormulario,
                child: Text("Enviar"))
            ],
          )),
      ),
    );
  }
  void _enviarFormulario(){
    if(_formKey.currentState!.validate()&&_aceite){
      _formKey.currentState!.save();
      showDialog(
        context: context,
        builder: (context)=>
      AlertDialog(
        title: Text("Dados do formulário"),
        content: Column(
          children: [
            Text("Nome: ${_nome}"),
            Text("Email: ${_email}"),
          ],
        ),
      ));
    }
  }
}
