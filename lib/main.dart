import 'package:Telemedicina_App/dashboard.dart';
import 'package:Telemedicina_App/login.dart';
import 'package:Telemedicina_App/splash.dart';
import 'package:flutter/material.dart';

void main() => runApp(App());



class App extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      routes: {
        '/login' : (context)=>Login(),
        '/dashboard' : (context)=>Dashboard(),
      },
      title: 'Telemedicina',
      theme: ThemeData(fontFamily: 'NotoSans'),
      home: Splash(),
    );
  }
}