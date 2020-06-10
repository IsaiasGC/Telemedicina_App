import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class Reportes extends StatelessWidget{
  List reportes;
  bool isLoading=false;

  Future<Null> _openInWebview(BuildContext context,String url) async {
    if (await url_launcher.canLaunch(url)) {
      Navigator.of(context).push(
        MaterialPageRoute(
          // *Note*: if got "ERR_CLEARTEXT_NOT_PERMITTED", modify
          // AndroidManifest.xml.
          // Cf. https://github.com/flutter/flutter/issues/30368#issuecomment-480300618
          builder: (ctx) => WebviewScaffold(
            initialChild: Center(child: CircularProgressIndicator()),
            url: url,
            appBar: AppBar(title: Text(url)),
          ),
        ),
      );
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('URL $url can not be launched.'),
        ),
      );
    }
  }
  getReportes(){
    this.reportes=[
      {
        "id": 1,
        "titulo": "Mapa de casos",
        "url": "https://news.google.com/covid19/map?hl=es-419&mid=/m/0259ws&gl=MX&ceid=MX:es-419"
      },
      {
        "id": 2,
        "titulo": "Secretaria de Salud Mexico",
        "url": "https://coronavirus.gob.mx/"
      },
      {
        "id": 3,
        "titulo": "Consejos acerca de los rumores",
        "url": "https://www.who.int/es/emergencies/diseases/novel-coronavirus-2019/advice-for-public/myth-busters"
      },
      {
        "id": 4,
        "titulo": "orientaciones para el público",
        "url": "https://www.who.int/es/emergencies/diseases/novel-coronavirus-2019/advice-for-public"
      }
    ];
  }
  @override
  Widget build(BuildContext context){
    getReportes();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Menu',
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        centerTitle: true,
        title: Text("Noticias"),
      ),
      body: Container( 
        color: Colors.blueAccent[100],
        // child: Center(child: IconButton(icon: const Icon(Icons.map), onPressed: (){_openInWebview(context, "https://news.google.com/covid19/map?hl=es-419&mid=/m/0259ws&gl=MX&ceid=MX:es-419");})),
        //https://www.who.int/es/emergencies/diseases/novel-coronavirus-2019/advice-for-public
        //https://www.who.int/es/emergencies/diseases/novel-coronavirus-2019/advice-for-public/myth-busters
        //https://coronavirus.gob.mx/
        //https://news.google.com/covid19/map?hl=es-419&mid=/m/0259ws&gl=MX&ceid=MX:es-419
        child: isLoading ? Center(child: CircularProgressIndicator(),)
            : ListView.builder(
              itemCount: reportes==null ? 0 : reportes.length,
              itemBuilder: (BuildContext context, int index) {
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: Card(
                    elevation: 8.0,
                    margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.5),
                    child: Container(
                          // decoration: BoxDecoration(color: Color.fromRGBO(50, 180, 237, .8)),
                          child: ListTile(
                            onTap: (){
                              _openInWebview(context, reportes[index]['url']);
                            },
                            contentPadding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 2.5),
                            leading: Container(
                              padding: reportes[index]['backdrop_path']!=null ? EdgeInsets.only(right: 5.0) : EdgeInsets.symmetric(horizontal: 27.0),
                              // decoration: BoxDecoration(
                              //   border: Border( right: BorderSide(width: 1.0, color: Colors.black))
                              // ),
                              child: reportes[index]['backdrop_path']!=null ? Image.network("https://image.tmdb.org/t/p/w500"+reportes[index]['backdrop_path'],) : Icon(Icons.link, size: 50.00, color: Theme.of(context).textTheme.bodyText1.color,),
                            ),
                            title: Text(
                              reportes[index]['titulo'],
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            // subtitle: Row(
                            //   children: <Widget>[
                            //     //Icon(Icons.touch_app, color: Colors.yellowAccent),
                            //     Text(reportes[index]['release_date'], style: Theme.of(context).textTheme.bodyText2)
                            //   ],
                            // ),
                            trailing: Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30.0,),
                          ),
                        ),
                  ),
                );
              },
        )
      )
    );
  }
}