import 'package:Telemedicina_App/dashboard.dart';
import 'package:Telemedicina_App/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

class Splash extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => SplashForm();
}

class SplashForm extends State<Splash>{
  bool loged=false;
  Future isLoged() async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    setState(() {
      loged=(pref.getBool('loged')??false);
    });
  }

  @override
  void initState() {
    isLoged();
    super.initState();
  }
  @override
  Widget build(BuildContext context){
    return SplashScreen(
      seconds: 4,
      image: Image.asset("images/logo.png", height: 300,),
      navigateAfterSeconds: !loged ? Login() : Dashboard(),
      gradientBackground: new LinearGradient(
        colors: [
          Colors.blue[900], 
          Colors.black
        ], 
        begin: Alignment.center, 
        end: Alignment.bottomCenter
      ),
    );
  }
}