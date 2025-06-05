import 'package:flutter/material.dart';
import 'package:sa_petshop/controllers/consulta_controller.dart';
import 'package:sa_petshop/controllers/pet_controller.dart';
import 'package:sa_petshop/models/consulta_model.dart';
import 'package:sa_petshop/models/pet_model.dart';
import 'package:sa_petshop/view/agenda_consulta_screen.dart';

class DetalhePetScreen extends StatefulWidget {
  final int petId;
  const DetalhePetScreen({super.key, required this.petId});

  @override
  State<StatefulWidget> createState() {
    return _DetalhePetScreenState();
  }
}

class _DetalhePetScreenState extends State<DetalhePetScreen> {
  final PetController _petController = PetController();
  final ConsultaController _consultaController = ConsultaController();
  bool _isLoading = true;
  Pet? _pet;
  List<Consulta> _consultas = [];
  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  _carregarDados() async {
    setState(() {
      _isLoading = true;
    });
    try {
      _pet = await _petController.readPetById(widget.petId);
      _consultas = await _consultaController.readConsultaForPet(widget.petId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Exception: ${e}"))
      );
    }finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Deltalhe do Pet")),
      body: _isLoading
      ? Center(child: CircularProgressIndicator(),)
      : _pet == null
      ? Center(child: Text("Erro ao carregar o Pet"),)
      : Padding(padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Nome: ${_pet!.nome}", style: TextStyle(fontSize: 20)),
          Text("Raça: ${_pet!.raca}", style: TextStyle(fontSize: 20),),
          Text("Dono: ${_pet!.nomeDono}", style: TextStyle(fontSize: 20),),
          Text("Telefone: ${_pet!.telefoneDono}", style: TextStyle(fontSize: 20),),
          Divider(),
          Text("Consultas: ", style: TextStyle(fontSize: 20),),
          _consultas.isEmpty
          ? Center(child: Text("Não Existe Agendamentos para o Pet"),)
          : Expanded(child: ListView.builder(
            itemBuilder: (context, index){
              final consulta = _consultas[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  title: Text(consulta.tipoServico),
                  subtitle: Text(consulta.dataHoraFormatada),
                  trailing: IconButton(onPressed: ()=>_deleteConsulta(consulta.id!), icon: Icon(Icons.delete, color: Colors.red,)),
                ),
              );
            },
            ))
        ],
      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>AgendaConsultaScreen(petId: widget.petId,))),
      ),
    );
  }
  
  void _deleteConsulta(int consultaId) async{
    try {
      await _consultaController.deleteConsulta(consultaId);
      await _consultaController.readConsultaForPet(widget.petId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Consulta Deletada com sucesso"))
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Exception: $e"))
      );
    }
  }
}
