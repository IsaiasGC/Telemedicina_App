import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Login extends StatefulWidget{
  @override
  State<StatefulWidget> createState(){
    return LoginForm();
  }
}

class LoginForm extends State<Login>{
  final txtUserController = TextEditingController();
  final txtPwdController = TextEditingController();
  var checked=false;
  var loading=false;

  Future login(BuildContext context) async{
    if(txtUserController.value.text!='' && txtPwdController.value.text!=''){
      // setState(() {
      //   loading=true;
      // });
      // String bodyJSON='{ "email" : "${txtUserController.value.text}", "password" : "${txtPwdController.value.text}" }';
      // log(bodyJSON);
      // var response=await http.post('http://192.168.101.17:8000/api/login',
      //   headers: {
      //     "Content-Type": "application/json"
      //   },
      //   body: bodyJSON
      // );
      // print('Status code: ${response.statusCode}');
      // if(response.statusCode==200){
      //   SharedPreferences pref=await SharedPreferences.getInstance();
      //   await pref.setBool('loged', checked);
        Navigator.pushReplacementNamed(context, "/dashboard");
      // }
      // setState(() {
      //   loading=false;
      // });
    }
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("App Error"),
          content: Text("Error al Autenticarse, ingrese email y contraseña validos"),
          actions: <Widget>[
            new FlatButton(
              child: Text("Cerrar"),
              color: Colors.red,
              onPressed: (){
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }
  @override
  Widget build(BuildContext context) {
    
    final logo = Image.asset("images/logo.png", height: 55,);

    final txtUser = Container(
      decoration: BoxDecoration(
        color: Colors.white60,
        borderRadius: BorderRadius.circular(45.0)
      ),
      child:TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: txtUserController,
        decoration: InputDecoration(
          hintText: "Introduce el Usuario",
          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(45.0))
        ),
      ),
    );

    final txtPwd = Container(
      decoration: BoxDecoration(
        color: Colors.white60,
        borderRadius: BorderRadius.circular(45.0)
      ),
      child:TextFormField(
        controller: txtPwdController,
        obscureText: true,
        decoration: InputDecoration(
          hintText: "Introduce la contraseña",
          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(45.0))
        ),
      )
    );

    final check=Checkbox(
      value: checked, 
      onChanged: (bool val){
        setState((){
          checked=val;
        });
      },
      tristate: false,
      activeColor: Colors.blue[900],
      checkColor: Colors.white,
    );
    
    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
//          var codigo = await validateUser();
          //print(codigo);
//          if( codigo == 200 ){
            // Navigator.push(context, MaterialPageRoute(builder:(context)=>Dashboard()));
            login(context);
//          }else{
          //  showDialog(
          //      context: context,
          //      builder: (BuildContext context){
          //        return AlertDialog(
          //          title: Text("Mensaje de la APP"),
          //          content: Text("Error al Autenticarse, Lodged: " + checked.toString()),
          //          actions: <Widget>[
          //            new FlatButton(
          //              child: Text("Cerrar"),
          //              onPressed: (){
          //                Navigator.of(context).pop();
          //              },
          //            )
          //          ],
          //        );
          //      }
          //  );
//          }
        },
        padding: EdgeInsets.all(12),
        color: Colors.blue[900],
        child: Text('Entrar', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      body: Container( 
        color: Colors.blueAccent[100],
        child: Center(
          child: loading ? CircularProgressIndicator() : ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              logo,
              SizedBox(height: 30),
              txtUser,
              SizedBox(height: 30),
              txtPwd,
              SizedBox(height: 10),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  check,
                  Text("Mantener Sesion", style: TextStyle(fontSize: 10.0, color: Colors.blue[900]),),
                ],
              ),
              SizedBox(height: 10,),
              loginButton,

            ],
          ),
        ),
      ),
    );
  }

}