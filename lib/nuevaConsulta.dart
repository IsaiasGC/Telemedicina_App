import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NuevaConsulta extends StatefulWidget {
  @override
  _NuevaConsultaForm createState() => _NuevaConsultaForm();
}

class _NuevaConsultaForm extends State<NuevaConsulta> {
  final txtSintomasController = TextEditingController();
  File imageFile;
  var loading=false;
  String dropdownValue="One";
  
  Future<void> sendData() async{
    setState(() {
      loading=true;
    });
    Dio dio = new Dio();
    FormData formData = new FormData.fromMap({
      "id_paciente": 5,
      "sintomas": "ALgun sintoma o mas",
      "id_especialidad": 10,
      "file": imageFile
    });
    var response=await dio.post("/api/consultaCrear", data: formData);
    log("StatusCode: ${response.statusCode}");
    // if(response.statusCode==200){

    // }
    setState(() {
      loading=true;
    });
  }
  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Seleccionar Imagen"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Row(children: <Widget>[Text("Galeria "), Icon(Icons.photo)]),
                      onTap: () {
                        _openGallery(context);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Row(children: <Widget>[Text("Camara "), Icon(Icons.photo_camera)]),
                      onTap: () {
                        _openCamera(context);
                      },
                    )
                  ],
                ),
              )
          );
        }
    );
  }
  void _openGallery(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }
  void _openCamera(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }
  Widget _setImageView() {
    if (imageFile != null) {
      return Image.file(imageFile, width: 50);
    } else {
      return Container(
        padding: EdgeInsets.only(top: 10),
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white60,
          borderRadius: BorderRadius.circular(10.0)
        ),
        child:Text("Agregue una foto en el Icono",textAlign: TextAlign.center,)
      );
    }
  }
  Widget getDropdown(){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white60,
        borderRadius: BorderRadius.circular(10.0)
      ),
      child:DropdownButton<String>(
        value: dropdownValue,
        icon: Icon(Icons.arrow_drop_down),
        dropdownColor: Colors.grey[200],
        iconSize: 24,
        elevation: 20,
        // style: TextStyle(color: Colors.deepPurple, ),
        
        onChanged: (String newValue) {
          setState(() {
            dropdownValue = newValue;
          });
        },
        items: <String>['One', 'Two', 'Free', 'Four']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
  Widget getTextField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white60,
        borderRadius: BorderRadius.circular(20.0)
      ),
      child:TextField(
        controller: this.txtSintomasController,
        maxLines: 10,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          hintText: 'Describa sus sintomas...',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))
        ),
      ),
    );
  }
  Widget getCrearButton(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {

        },
        padding: EdgeInsets.all(12),
        color: Colors.blue[900],
        child: Text('Generar Consulta', style: TextStyle(color: Colors.white)),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 48, 110, 1),
        leading: IconButton(
          tooltip: 'Regresar',
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context,null);
          },
        ),
        centerTitle: true,
        title: Text("Relizar Consulta"),
      ),
      body: Container( 
        color: Colors.blueAccent[100],
        child: Center(
          child: loading ? CircularProgressIndicator() : ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              getDropdown(),
              SizedBox(height: 30),
              getTextField(),
              SizedBox(height: 30),
              _setImageView(),
              SizedBox(height: 10,),
              getCrearButton(),

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showSelectionDialog(context);
        },
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}