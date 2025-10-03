import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(home: WifiStatusScreen(), debugShowCheckedModeBanner: false),
  );
}

class WifiStatusScreen extends StatefulWidget {
  const WifiStatusScreen({super.key});

  @override
  State<WifiStatusScreen> createState() => _WifiStatusScreenState();
}

class _WifiStatusScreenState extends State<WifiStatusScreen> {
  String _mensagem = "";

  late StreamSubscription<List<ConnectivityResult>> _conexao;

  //status da conexao no comeco da aplicacao
  void _checkInicialConnection() async {
    ConnectivityResult result = (await Connectivity().checkConnectivity())
    as ConnectivityResult;
    _updateStatusConnection(result);
  }

  //quando houver mudanca de status da conexao identificar
  void _updateStatusConnection(ConnectivityResult result) async {
    setState(() {
      switch (result) {
        case ConnectivityResult.wifi:
          _mensagem = "Conectado no WIFI";
          break;
        case ConnectivityResult.mobile:
          _mensagem = "Conectado Via Dados Móveis";
          break;
        case ConnectivityResult.none:
          _mensagem = "Sem Conexão com a Internet";
        default:
          _mensagem = "Procurando Conexão";
          break;
      }
    });
  }
  @override
  void initState() {
    super.initState();
    _checkInicialConnection();
    _conexao = Connectivity().onConnectivityChanged.listen(
      (List<ConnectivityResult> results){
        final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
        _updateStatusConnection(result);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 14, 136, 236),
        title: Text("Status da Conexão", style: TextStyle(color: Colors.white),),
      ), 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _mensagem.contains("WIFI") ? Icons.wifi :
              _mensagem.contains("Dados") ? Icons.network_cell
              : Icons.wifi_off,
              size: 80,
              color: _mensagem.contains("Sem Conexão") ? Colors.red : Colors.blue,
            ),
            SizedBox(height: 10,),
            Text("Status: $_mensagem")
          ],
        ),
      )
    );
  }
}
