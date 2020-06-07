import 'package:Telemedicina_App/nuevaConsulta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Consultas extends StatefulWidget{
  const Consultas({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => ConsultasForm();
}

class ConsultasForm extends State<Consultas>{
  List consultas;
  bool isLoading=true;

  Future<String> getConsultas() async{
    String bodyJSON='{ "id_paciente" : ${5} }';
    var response=await http.post('http://192.168.101.17:8000/api/consultasPaciente',
      headers: {
        "Accept": "application/json",
      },
      body: bodyJSON
    );
    
    print('Status code: ${response.statusCode}');
    if(response.statusCode==200){
        this.consultas=convert.jsonDecode(response.body);
    }
    return "Accept";
  }

  Widget getConsultsList(BuildContext context){
    return ListView.builder(
      itemCount: consultas==null ? 0 : consultas.length,
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
                      padding: consultas[index]['foto_sintomas']!=null ? EdgeInsets.only(right: 5.0) : EdgeInsets.symmetric(horizontal: 27.0),
                      // decoration: BoxDecoration(
                      //   border: Border( right: BorderSide(width: 1.0, color: Colors.black))
                      // ),
                      child: consultas[index]['foto_sintomas']!=null ? Image.network("http://192.168.101.17:8000/uploads/"+consultas[index]['foto_sintomas'], width: 100,) : Icon(Icons.photo, size: 50.00, color: Theme.of(context).textTheme.bodyText1.color,),
                    ),
                    title: Text(
                      consultas[index]['especialidad'],
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
            //     //     builder: (context) => ViewDetails(consultas[index], internet),
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
        title: Text("Consultas"),
        actions: <Widget>[
          IconButton(
            tooltip: 'Nueva Consulta',
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NuevaConsulta(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container( 
        color: Colors.blueAccent[100],
        child: FutureBuilder<String>(
          future: getConsultas(),
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