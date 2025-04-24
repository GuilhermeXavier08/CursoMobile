import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.light,
    ),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
    ),
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget{
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  bool _darkMode = false;
  @override
  void initState(){
    super.initState();
    _carregarPreferencias();
  }

  void _carregarPreferencias() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool("darkMode")?? false;
    });
  }
  void mudarDarkMode()async{
    setState(() {
      _darkMode = !_darkMode;

    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("darkMode", _darkMode);
    _carregarPreferencias();
  }
  @override
  Widget build(BuildContext context){
    return AnimatedTheme(
      data: _darkMode ? ThemeData.dark(): ThemeData.light(),
      duration: Duration(microseconds: 500),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Teste DarkMode"),
          centerTitle: true,
          backgroundColor: Colors.blue,
          ),
        body: Center(
          child: Switch(value: _darkMode, onChanged: (value) => mudarDarkMode()),
        ),
      )
    );
  }
}