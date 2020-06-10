import 'package:Telemedicina_App/nuevaConsulta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Historial extends StatefulWidget{
  final int id;
  const Historial(this.id,{Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => HistorialForm(id);
}

class HistorialForm extends State<Historial>{
  final int id;
  List historial;
  bool isLoading=true;

  HistorialForm(this.id);

  Future<String> getHistorial() async{
    String bodyJSON='{ "id_paciente" : ${5} }';
    var response=await http.post('http://192.168.101.17:8000/api/consultasPacienteAte',
      headers: {
        "Accept": "application/json",
      },
      body: bodyJSON
    );
    
    print('Status code: ${response.statusCode}');
    if(response.statusCode==200){
        this.historial=convert.jsonDecode(response.body);
    }
    return "Accept";
  }

  Widget getConsultsList(BuildContext context){
    return ListView.builder(
      itemCount: Historial==null ? 0 : historial.length,
      itemBuilder: ( context, int index) {
        return Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: Card(
            color: Colors.grey[100],
            elevation: 8.0,
            margin: EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.5),
            child: Container(
                  // decoration: BoxDecoration(color: Color.fromRGBO(50, 180, 237, .8)),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 2.5),
                    leading: Container(
                      padding: historial[index]['foto_sintomas']!=null ? EdgeInsets.only(right: 5.0) : EdgeInsets.symmetric(horizontal: 27.0),
                      // decoration: BoxDecoration(
                      //   border: Border( right: BorderSide(width: 1.0, color: Colors.black))
                      // ),
                      child: historial[index]['foto_sintomas']!=null ? Image.network("http://192.168.101.17:8000/uploads/"+historial[index]['foto_sintomas'], width: 100,) : Icon(Icons.photo, size: 50.00, color: Theme.of(context).textTheme.bodyText1.color,),
                    ),
                    title: Text(
                      historial[index]['especialidad'],
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    subtitle: Row(
                      children: <Widget>[
                        //Icon(Icons.touch_app, color: Colors.yellowAccent),
                        Text("fecha dd/mm/aaaa", style: Theme.of(context).textTheme.bodyText2)
                      ],
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30.0,),
                  ),
                ),
          ),
          actions: <Widget>[
            IconSlideAction(
              foregroundColor: Colors.red,
              caption: 'Eliminar',
              color: Colors.blueAccent[100],
              icon: Icons.delete,
              onTap: () => {
              },
            ),
            // IconSlideAction(
            //   foregroundColor: Colors.blue[700],
            //   caption: 'Ver',
            //   color: Colors.blueAccent[100],
            //   icon: Icons.open_in_new,
            //   onTap: () => {
            //     // Navigator.push(
            //     //   context,
            //     //   MaterialPageRoute(
            //     //     builder: (context) => ViewDetails(Historial[index], internet),
            //     //   ),
            //     // )
            //   },
            // ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 48, 110, 1),
        leading: IconButton(
          tooltip: 'Menu',
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        centerTitle: true,
        title: Text("Historial"),
      ),
      body: Container( 
        color: Colors.blueAccent[100],
        child: FutureBuilder<String>(
          future: getHistorial(),
          builder: (context, snapshot){
            if(snapshot.connectionState==ConnectionState.done){
              return getConsultsList(context);
            }else{
              return Center(child: CircularProgressIndicator(),);
            }
          }
        )
      )
    );
  }
}