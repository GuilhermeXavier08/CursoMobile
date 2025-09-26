import 'package:cine_favorite/view/home_view.dart';
import 'package:cine_favorite/view/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  //garante o carregamento dos widgets
  WidgetsFlutterBinding.ensureInitialized();

  //conecta com o firebase
  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "CineFavorite",
    theme: ThemeData(
      primarySwatch: Colors.orange,
    ),
    home: AuthStream(),
  ));
}

//verifica se o usuario esta logado ou nao no sistema e direciona de acordo com a decisao
class AuthStream extends StatelessWidget {
  const AuthStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(//permite o usuario null
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot){
        if (snapshot.hasData) {
          return HomeView();
        }
        return LoginView();
      },
      
    );
  }
}
