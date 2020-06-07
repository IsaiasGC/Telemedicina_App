import 'package:Telemedicina_App/consultas.dart';
import 'package:Telemedicina_App/historial.dart';
import 'package:Telemedicina_App/reportes.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget{
  const Dashboard({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => DashboardForm();
}

class DashboardForm extends State<Dashboard>{
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final navPages = <Widget>[
      Consultas(),
      Historial(),
      Reportes(),
    ];
    final drawerDashboard = Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("El Isa"),
            accountEmail: Text("15030094@itcelaya.edu.mx"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage("https://avatars2.githubusercontent.com/u/44481689?s=460&v=4"),
            ),
            decoration: BoxDecoration(color: Colors.blue[700]),
          ),
          ListTile(
            title: Text("Consultas"),
            leading: Icon(Icons.local_hospital),
            trailing: Icon(Icons.arrow_right),
            onTap: (){
              // Navigator.pushNamed(context, '/course');
              setState(() {
                index=0;
              });
            },
          ),
          ListTile(
            title: Text("Historial"),
            leading: Icon(Icons.bookmark),
            trailing: Icon(Icons.arrow_right),
            onTap: (){
              // Navigator.pushNamed(context, '/course');
              setState(() {
                index=1;
              });
            },
          ),
          ListTile(
            title: Text("Covid-19"),
            leading: Icon(Icons.bug_report),
            trailing: Icon(Icons.arrow_right),
            onTap: (){
              // Navigator.pushNamed(context, '/course');
              setState(() {
                index=2;
              });
            },
          ),
        ],
      ),
    );
    final scaffoldDrawer=Scaffold(
      body: Center(
        child: navPages[index]
      ),
      drawer: drawerDashboard,
    );
    return scaffoldDrawer;
  }
}