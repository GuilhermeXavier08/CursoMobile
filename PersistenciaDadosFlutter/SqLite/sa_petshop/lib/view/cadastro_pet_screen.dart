import 'package:flutter/material.dart';
import 'package:sa_petshop/controllers/pet_controller.dart';
import 'package:sa_petshop/models/pet_model.dart';
import 'package:sa_petshop/view/home_screen.dart';

class CadastroPetScreen extends StatefulWidget {
  @override
  State<CadastroPetScreen> createState() => _CadastroPetScreenState();
}

class _CadastroPetScreenState extends State<CadastroPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controllerPet = PetController();

  late String _nome = "";
  late String _raca = "";
  late String _nomeDono = "";
  late String _telefoneDono = "";

  _salvarPet() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newPet = Pet(
        nome: _nome,
        raca: _raca,
        nomeDono: _nomeDono,
        telefoneDono: _telefoneDono,
      );
      await _controllerPet.createPet(newPet);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Novo Pet")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Nome do Pet", border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? "Campo não preenchido" : null,
                onSaved: (value) => _nome = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Raça do Pet", border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? "Campo não preenchido" : null,
                onSaved: (value) => _raca = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Dono do Pet", border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? "Campo não preenchido" : null,
                onSaved: (value) => _nomeDono = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Telefone do Dono", border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? "Campo não preenchido" : null,
                onSaved: (value) => _telefoneDono = value!,
              ),
              ElevatedButton(onPressed: _salvarPet, child: Text("Cadastrar Pet")),
            ],
          )
          ),
        ),
    );
  }
}
