import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Reportes extends StatelessWidget{
  List reportes;
  bool isLoading=true;

  @override
  Widget build(BuildContext context){
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
                            contentPadding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 2.5),
                            leading: Container(
                              padding: reportes[index]['backdrop_path']!=null ? EdgeInsets.only(right: 5.0) : EdgeInsets.symmetric(horizontal: 27.0),
                              // decoration: BoxDecoration(
                              //   border: Border( right: BorderSide(width: 1.0, color: Colors.black))
                              // ),
                              child: reportes[index]['backdrop_path']!=null ? Image.network("https://image.tmdb.org/t/p/w500"+reportes[index]['backdrop_path'],) : Icon(Icons.photo, size: 50.00, color: Theme.of(context).textTheme.bodyText1.color,),
                            ),
                            title: Text(
                              reportes[index]['title'],
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            subtitle: Row(
                              children: <Widget>[
                                //Icon(Icons.touch_app, color: Colors.yellowAccent),
                                Text(reportes[index]['release_date'], style: Theme.of(context).textTheme.bodyText2)
                              ],
                            ),
                            // trailing: Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30.0,),
                          ),
                        ),
                  ),
                  actions: <Widget>[
                    IconSlideAction(
                      foregroundColor: Colors.red,
                      caption: 'Eliminar',
                      color: Colors.grey[850],
                      icon: Icons.delete,
                      onTap: () => {
                      },
                    ),
                    IconSlideAction(
                      foregroundColor: Color.fromARGB(255, 23, 162, 184),
                      caption: 'Ver',
                      color: Colors.grey[850],
                      icon: Icons.open_in_new,
                      onTap: () => {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => ViewDetails(reportes[index], internet),
                        //   ),
                        // )
                      },
                    ),
                  ],
                );
              },
        )
      )
    );
  }
}