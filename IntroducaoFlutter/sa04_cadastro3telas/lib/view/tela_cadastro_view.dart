import 'package:flutter/material.dart';

class TelaCadastro extends StatefulWidget{
  _TelaCadastroState createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro>{
  final _formKey = GlobalKey<FormState>();
  String _nome = "";
  String _email = "";
  String _senha = "";
  String _genero = "";
  String _dataNascimento = "";
  double _experiencia = 0;
  bool _aceite = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tela Cadastro"),centerTitle: true,),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            //Criar a Validação dos Dados do formulários para mudar de tela
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
                onPressed: ()=> _enviarFormulario(), 
                child: Text("Enviar")),
                ElevatedButton(
                onPressed: ()=> Navigator.pushNamed(context, "/"), 
                child: Text("Voltar")),
          ],
        ),),
    );
  }
  void _enviarFormulario() {
    if (_formKey.currentState!.validate() && _aceite) {
      _formKey.currentState!.save();
      Navigator.pushNamed(context, "/confirmacao");
    }
  }
}