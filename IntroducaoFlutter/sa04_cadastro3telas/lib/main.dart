import 'package:flutter/material.dart';
import 'package:sa04_cadastro3telas/view/tela_confirmacao.dart';

import 'view/tela_boas_vindas_view.dart';
import 'view/tela_cadastro_view.dart';
import 'view/tela_confirmacao.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: "/",
    routes: {
      "/": (context)=> TelaBoasVindas(),
      "/cadastro":(context)=>TelaCadastro(),
      "/confirmacao":(context)=>TelaConfirmacao()
    },
  ));
}