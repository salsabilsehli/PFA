import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hello_world/auth.dart';
import 'package:flutter_hello_world/services/DatabaseService.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class ReminderPage extends StatefulWidget {

  final FirebaseUser currentUser;

  ReminderPage(this.currentUser);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<ReminderPage> {

  Map<String,String> notesP;

  final CollectionReference NoteProfS1Collection =  Firestore.instance.collection(
  "Etudiants").document("GI1").collection("S1").document("Notes des profs").collection("notes de profs");
final CollectionReference EtudiantSettings = Firestore.instance.collection("EtudiantsSettings");
final CollectionReference Etudiants = Firestore.instance.collection("Etudiants");

  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  TextEditingController _eventController = new TextEditingController();

  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _eventController = TextEditingController();
    _events = {};
    _selectedEvents = [];
    initPrefs();
  }

  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _events = Map<DateTime, List<dynamic>>.from(
          decodeMap(json.decode(prefs.getString("events") ?? "{}")));
    });
  }

  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }

  Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[DateTime.parse(key)] = map[key];
    });
    return newMap;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Calendrier '),
      ),

      body:


      Center(

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            TableCalendar(
              events: _events,
              initialCalendarFormat: CalendarFormat.month,
              calendarStyle: CalendarStyle(
                  canEventMarkersOverflow: true,
                  todayColor: Colors.pink,
                  selectedColor: Theme
                      .of(context)
                      .primaryColor,
                  todayStyle: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 18.0,
                      color: Colors.white)),
              headerStyle: HeaderStyle(
                centerHeaderTitle: true,
                formatButtonDecoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                formatButtonTextStyle: TextStyle(color: Colors.white),
                formatButtonShowsNext: false,
              ),
              startingDayOfWeek: StartingDayOfWeek.monday,
              onDaySelected: (date, events) {
                setState(() {
                  _selectedEvents = events;
                });
              },
              builders: CalendarBuilders(
                selectedDayBuilder: (context, date, events) =>
                    Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Theme
                                .of(context)
                                .primaryColor,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(color: Colors.white),
                        )),
                todayDayBuilder: (context, date, events) =>
                    Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.pink,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(color: Colors.white),
                        )),
              ),
              calendarController: _controller,
            ),
            Text("\n "),
         FloatingActionButton.extended(
           heroTag: "btn1",
           onPressed: () async {
              final FirebaseUser currentUser= await Provider.of<AuthService>(context).getUser();
                  EtudiantSettings.getDocuments().then((querySnapshot) {
              querySnapshot.documents.forEach((result) {
              if (currentUser.uid == result.data["uid"]) {
                Etudiants.document(result.data["niveau"]).collection(result.data["section"]).document(currentUser.uid).collection("notes perso").getDocuments().then((querySnapshot) {
                  querySnapshot.documents.forEach((result) {
                    void _showDialog() {
                      // flutter defined function
                      showDialog(

                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: new Text(result.data.values.toString()),
                            content: new Text(result.data.toString()),

                            actions: <Widget>[
                              // usually buttons at the bottom of the dialog
                              new FlatButton(

                                child: new Text("Next"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );

                        },
                      );

                    }
                    _showDialog();

                  } );
                });







              }
    });
    });

    },



           label: Text('notes perso'),
           icon: Icon(Icons.sync),
           backgroundColor: Colors.lightBlueAccent,
          ),
          Text("\n \n \n"),

           FloatingActionButton.extended(
             heroTag: "btn2",
              onPressed: () async {
                final FirebaseUser currentUser= await Provider.of<AuthService>(context).getUser();
                  EtudiantSettings.getDocuments().then((querySnapshot) {
                  querySnapshot.documents.forEach((result) {
                  if(currentUser.uid==result.data["uid"]){
                  Etudiants.document(result.data["niveau"]).collection(result.data["section"]).document("Notes des profs").collection("notes de profs").getDocuments().then((querySnapshot) {
                  querySnapshot.documents.forEach((result) {
                      void _showDialog() {
                // flutter defined function
                    showDialog(

            context: context,
               builder: (BuildContext context) {
                 return AlertDialog(
                   title: new Text("notes du prof "+result.data.keys.toString()),
                    content: new Text(result.data.toString()),

                    actions: <Widget>[
              // usually buttons at the bottom of the dialog
                      new FlatButton(

                          child: new Text("Next"),
                          onPressed: () {
                          Navigator.of(context).pop();
                                },
                        ),

                      ],
                      );

                            },
                    );

                        }
              _showDialog();

    } );
    });

    }
    } );
    });
              },

              label: Text('notes prof'),
              icon: Icon(Icons.sync),
              backgroundColor: Colors.redAccent,

            ),




          ],
        ),


      ),

      floatingActionButton: FloatingActionButton(

        child: Icon(Icons.add),

        onPressed:

        _showAddDialog,
      ),


    );
  }


  _showAddDialog() {
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              content: TextField(
                controller: _eventController,
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("ok"),
                  onPressed: () async {

                    if (_eventController.text.isEmpty) return;
                    setState(() async{
                      if (_events[_controller.selectedDay] != null) {
                        _events[_controller.selectedDay].add(
                            _eventController.text);

                      } else {
                        _events[_controller.selectedDay] =
                        [_eventController.text];
                      }

                      final FirebaseUser currentUser= await Provider.of<AuthService>(context).getUser();
                      EtudiantSettings.getDocuments().then((querySnapshot) {
                        querySnapshot.documents.forEach((result) async {
                          if(currentUser.uid==result.data["uid"]) {
                            if (result.data["niveau"] == "GI1") {
                              if(result.data["section"] == "S1") {
                                await Databaseservice(currentUser.uid).addnoteGI1S1(_events.toString());
                              }
                              else if(result.data["section"] == "S2") {
                                await Databaseservice(currentUser.uid).addnoteGI1S2(_events.toString());
                              }
                            }

                          }
                        });
                      });
                      //await Databaseservice(currentUser.uid).addnote(_events.toString());

                      Navigator.pop(context);

                      //await Databaseservice(currentUser.uid).addnote(_events.toString());



                    }
                    );
                  },
                )
              ],
            )
    );
  }
}

