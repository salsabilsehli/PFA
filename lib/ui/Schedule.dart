import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hello_world/ui/AllNotifications.dart';
import 'package:flutter_hello_world/ui/Reminder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth.dart';
import '../data/days.dart';
import '../data/professors.dart';
import '../data/timetable.dart';


class SchedulePage extends StatefulWidget {
  final FirebaseUser currentUser;

  SchedulePage(this.currentUser);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<SchedulePage> {
  final db = Firestore.instance;

  int _weekDay = DateTime.now().weekday;
  String _class;
  SharedPreferences _sharedPreferences;

  @override
  void initState() {
    super.initState();
    getDefaults();
  }

  void getDefaults() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _class = _sharedPreferences.getString('class');
    });
  }

  @override
  Widget build(BuildContext context) {
    dynamic cardData = 'Vancance';
    int i = 0;
    if (_weekDay < 6 && _class != null) {
      List<String> timings = timetable[_class][_weekDay].keys.toList();
      cardData = timetable[_class][_weekDay]
          .values
          .map((lecture) => ListTile(
        trailing: Text(
          timings[i++],
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Theme.of(context).primaryColorBrightness ==
                Brightness.dark
                ? Colors.white
                : Colors.black,
            fontStyle: FontStyle.italic,
          ),
        ),
        isThreeLine: true,
        subtitle: Text(
          professors[_class.substring(0, 3)][lecture.contains('Lab')
              ? lecture.split('-')[0].trim()
              : lecture]
              .toString(),
          style: TextStyle(
              color: Theme.of(context).primaryColorBrightness ==
                  Brightness.dark
                  ? Colors.white70
                  : Colors.black54),
        ),
        title: Text(
          lecture,
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).primaryColorBrightness ==
                Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
      ))
          .toList();
    }
    return _class == null
        ? Scaffold(
      appBar: AppBar(
        title: Text('Selectionner Classe par defaut'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(8),
              child: DropdownButtonFormField(
                items: [
                  DropdownMenuItem(
                    child: Text('GI 1 - S1'),
                    value: 'GI1S1',
                  ),
                  DropdownMenuItem(
                    child: Text('GI 1 - S2'),
                    value: 'GI1S2',
                  ),
                  DropdownMenuItem(
                    child: Text('GI 1 - S3'),
                    value: 'GI1S3',
                  ),
                  DropdownMenuItem(
                    child: Text('GI 1 - S4'),
                    value: 'GI1S4',
                  ),
                 /* DropdownMenuItem(
                    child: Text('7 IT - 1'),
                    value: '7IT1',
                  ),
                  DropdownMenuItem(
                    child: Text('7 IT - 2'),
                    value: '7IT2',
                  ),*/
                ],
                hint: Text('Selectionner Classe par defaut'),
                value: _class,
                onChanged: (v) {
                  showDialog(
                      context: context,
                      builder: (builder) {
                        return AlertDialog(
                          title: Text(
                              'Voulez vous mettre  \"$v\" comme classe par defaut.'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Annuler'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            FlatButton(
                              child: Text(
                                'OK',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () async {
                                setState(() async {
                                  _class = v;
                                  _sharedPreferences.setString(
                                      'class', _class);
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ],

                        );
                      });
                },
              ),
            ),
          ],
        ),
      ),
    )
        : Scaffold(
      appBar: AppBar(
        title: Text('Emploi'),
        actions: <Widget>[
          GestureDetector(
            child: Center(
              child: Container(
                margin: EdgeInsets.only(right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.school,
                          size: 20,
                        )),
                    Text(_class)
                  ],
                ),
              ),
            ),
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (builder) => Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              'GI 1 - S1',
                              textAlign: TextAlign.center,
                            ),
                            onTap: () {
                              setState(() {
                                _class = 'GI1S1';
                                Navigator.of(context).pop();
                              });
                            },
                          ),
                          ListTile(
                            title: Text(
                              'GI 1 - S2',
                              textAlign: TextAlign.center,
                            ),
                            onTap: () {
                              setState(() {
                                _class = 'GI1S2';
                                Navigator.of(context).pop();
                              });
                            },
                          ),
                          ListTile(
                            title: Text(
                              'GI 1 - S3',
                              textAlign: TextAlign.center,
                            ),
                            onTap: () {
                              setState(() {
                                _class = 'GI1S3';
                                Navigator.of(context).pop();
                              });
                            },
                          ),
                          ListTile(
                            title: Text(
                              'GI 1 - S4',
                              textAlign: TextAlign.center,
                            ),
                            onTap: () {
                              setState(() {
                                _class = 'GI1S4';
                                Navigator.of(context).pop();
                              });
                            },
                          ),
                         /* ListTile(
                            title: Text(
                              'GI 2 - 1',
                              textAlign: TextAlign.center,
                            ),
                            onTap: () {
                              setState(() {
                                _class = 'GIIT1';
                                Navigator.of(context).pop();
                              });
                            },
                          ),
                          ListTile(
                            title: Text(
                              'GI IT - 2',
                              textAlign: TextAlign.center,
                            ),
                            onTap: () {
                              setState(() {
                                _class = 'GIIT2';
                                Navigator.of(context).pop();
                              });
                            },
                          ),*/
                        ],
                      ),
                    ),
                  ));
            },
          ),
          GestureDetector(
            child: Center(
              child: Container(
                margin: EdgeInsets.only(right: 12),
                child: Row(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.today,
                          size: 20,
                        )),
                    Text(days[_weekDay]),
                  ],
                ),
              ),
            ),
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (builder) => Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              'Aujourd hui',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _weekDay = DateTime.now().weekday;
                                Navigator.of(context).pop();
                              });
                            },
                          ),
                          ListTile(
                            title: Text(
                              'Lundi',
                              textAlign: TextAlign.center,
                            ),
                            onTap: () {
                              setState(() {
                                _weekDay = 1;
                                Navigator.of(context).pop();
                              });
                            },
                          ),
                          ListTile(
                            title: Text(
                              'Mardi',
                              textAlign: TextAlign.center,
                            ),
                            onTap: () {
                              setState(() {
                                _weekDay = 2;
                                Navigator.of(context).pop();
                              });
                            },
                          ),
                          ListTile(
                            title: Text(
                              'Mercredi',
                              textAlign: TextAlign.center,
                            ),
                            onTap: () {
                              setState(() {
                                _weekDay = 3;
                                Navigator.of(context).pop();
                              });
                            },
                          ),
                          ListTile(
                            title: Text(
                              'Jeudi',
                              textAlign: TextAlign.center,
                            ),
                            onTap: () {
                              setState(() {
                                _weekDay = 4;
                                Navigator.of(context).pop();
                              });
                            },
                          ),
                          ListTile(
                            title: Text(
                              'Vendredi',
                              textAlign: TextAlign.center,
                            ),
                            onTap: () {
                              setState(() {
                                _weekDay = 5;
                                Navigator.of(context).pop();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ));
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.yellow),
              child: Center(
                  child: Image.asset(
                    'assets/app.png',
                    width: 70,
                    height: 70,
                  )),
            ),
            InkWell(
              splashColor: Colors.white,
              child: ListTile(
                leading: Icon(Icons.people),
                title: Text('Notifications'),
                onTap: () async{

                  final FirebaseUser currentUser= await Provider.of<AuthService>(context).getUser();
                  Navigator.push(context, new MaterialPageRoute(builder: (context) => AllNotifications(currentUser)));
                },
              ),
            ),
            InkWell(
              splashColor: Colors.white,
              child: ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text('Calendrier'),
                onTap: () async{
                  final FirebaseUser currentUser= await Provider.of<AuthService>(context).getUser();
                  Navigator.push(context, new MaterialPageRoute(builder: (context) => ReminderPage(currentUser)));



                },
              ),
            ),
            InkWell(
              splashColor: Colors.white,
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text('Paramètres'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/Etud/settings');
                },
              ),
            ),
            InkWell(
              splashColor: Colors.white,
              child: ListTile(
                leading: Icon(Icons.info),
                title: Text('StudTime'),
                onTap: () {
                  Navigator.pop(context);
                  showAboutDialog(
                      context: context,
                      applicationName: "StudTime",
                      applicationVersion: "1.0.0",
                      applicationIcon: Image.asset(
                        'assets/app.png',
                        width: 45,
                      ),
                      children: [
                        Text("PFA Enis"),
                        Text(
                          "\nFait Avec \u2764 ",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )
                      ]);
                },
              ),
            ),
            InkWell(
                splashColor: Colors.white,
                child: ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('DECONNECTER'),
                    onTap: () async{
                      await Provider.of<AuthService>(context).logout();

                    })
            )
          ],
        ),
      ),
      body: Container(
        child: TimeTableCard(cardData),
      ),
    );
  }
}

class TimeTableCard extends StatelessWidget {
  final dynamic _data;

  TimeTableCard(this._data);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Theme.of(context).primaryColor,
        margin: EdgeInsets.all(30),
        child: Center(
          child: _data is List
              ? ListView(
            children: <Widget>[
              ..._data,
            ],
            padding: EdgeInsets.all(24),
          )
              : Text(
            _data,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 30,
                letterSpacing: 3,
                color: Theme.of(context).primaryColorBrightness ==
                    Brightness.dark
                    ? Colors.white
                    : Colors.black),
          ),
        ),
      ),
    );
  }
}