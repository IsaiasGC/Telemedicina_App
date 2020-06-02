import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget{
  const Dashboard({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => DashboardForm();
}

class DashboardForm extends State<Dashboard>{
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final _kTabPages = <Widget>[
    ];
    final _kBottmonNavBarItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(Icons.movie), title: Text('popular')),
      BottomNavigationBarItem(icon: Icon(Icons.search), title: Text('search')),
      BottomNavigationBarItem(icon: Icon(Icons.favorite), title: Text('favorite')),
    ];
    assert(_kTabPages.length == _kBottmonNavBarItems.length);
    final bottomNavBar = BottomNavigationBar(
      items: _kBottmonNavBarItems,
      currentIndex: _currentTabIndex,
      fixedColor: Colors.blueAccent[100],
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).primaryColor,
      onTap: (int index) {
        setState(() {
          _currentTabIndex = index;
        });
      },
    );
    return Scaffold(
      body: Center(
        child: _kTabPages[_currentTabIndex]
      ),
      bottomNavigationBar: bottomNavBar,
    );
  }
}