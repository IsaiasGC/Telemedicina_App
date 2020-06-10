import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class NuevaConsulta extends StatefulWidget {
  final int id;
  const NuevaConsulta(this.id);
  @override
  _NuevaConsultaForm createState() => _NuevaConsultaForm(id);
}

class _NuevaConsultaForm extends State<NuevaConsulta> {
  final int id;
  final txtSintomasController;
  File imageFile;
  var loading=false;
  int dropdownValue;
  List especialidades;
  String imagePath;

  _NuevaConsultaForm(this.id)
    : txtSintomasController = TextEditingController();
  
  @override
  initState(){
    super.initState();
    getEspecialidades();
  }

  Future<void> sendData(BuildContext context) async{
    setState(() {
      loading=true;
    });
    Dio dio = new Dio();
    FormData formData = new FormData.fromMap({
      "id_paciente": id,
      "sintomas": txtSintomasController.value.text,
      "id_especialidad": dropdownValue,
      // "files":{
        "foto":  imageFile!=null ? await MultipartFile.fromFile(imageFile.path, filename: "fotoSintoma.jpg") : null
      // }
    });
    var response=await dio.post("http://192.168.101.17:8000/api/consultasCrear", 
      data: formData,
      onSendProgress: (int sent, int total) {
        print("$sent / $total");
      },
    );
    log("StatusCode: ${response.statusCode}");
    if(response.statusCode==200){
      Navigator.pop(context, true);
    }
    setState(() {
      loading=false;
    });
  }
  Future<String> getEspecialidades() async{
    setState(() {
      loading=true;
    });
    var response=await http.get('http://192.168.101.17:8000/api/especialidades',
      headers: {
        "Accept": "application/json",
      },
    );
    
    print('Status code: ${response.statusCode}');
    if(response.statusCode==200){
        this.especialidades=convert.jsonDecode(response.body);
    }
    setState(() {
      loading=false;
    });
    return "Accept";
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
    if(picture!=null){
      await getApplicationDocumentsDirectory().then((value) => imagePath=value.path+"/fotoSintoma.jpg");
      log("Path nuevo: $imagePath");
      await picture.copy(imagePath).then((value) => {
        this.setState(() {
          imageFile = value;
        })
      });
      log("Path nuevo File: ${imageFile.path}");
    }
    Navigator.of(context).pop();
  }
  Widget _setImageView() {
    if (imageFile != null) {
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white60,
          borderRadius: BorderRadius.circular(10.0)
        ),
        child:Image.file(imageFile, height: 200)
      );
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
      child:DropdownButton<int>(
        hint: Text("Elija una especialidad"),
        value: dropdownValue,
        icon: Icon(Icons.arrow_drop_down),
        dropdownColor: Colors.grey[200],
        iconSize: 24,
        elevation: 20,
        onChanged: (int newValue) {
          setState(() {
            dropdownValue = newValue;
          });
        },
        items: especialidades
            .map<DropdownMenuItem<int>>((esp) {
          return DropdownMenuItem<int>(
            value: int.parse(esp["id"]),
            child: Text(esp["especialidad"]),
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
  Widget getCrearButton(BuildContext context){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          sendData(context);
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
            Navigator.pop(context,false);
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
              getCrearButton(context),

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