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
    return !loged ? Login() : SplashScreen(
      seconds: 4,
      image: Image.network("https://icons-for-free.com/iconfiles/png/512/clapper+cut+director+making+movie+take+icon-1320195777589696004.png"),
      navigateAfterSeconds: Dashboard(),
      title: Text("Medilife", 
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      gradientBackground: new LinearGradient(
        colors: [new Color.fromRGBO(150, 10, 10, 0.8), Colors.black], 
        begin: Alignment.center, 
        end: Alignment.bottomCenter
      ),
    );
  }
}