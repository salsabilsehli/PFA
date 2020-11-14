import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hello_world/services/DatabaseService.dart';
import 'package:provider/provider.dart';

import '../auth.dart';

enum Filiere { info, civil,electrique }
enum Niveau {G1,G2,G3}
enum Section {S1,S2,S3,S4}
class ChoosePage extends StatefulWidget {

  final FirebaseUser currentUser;
  ChoosePage(this.currentUser);

  @override
  State<StatefulWidget> createState() => _ChoosePageState();
}

class _ChoosePageState extends State<ChoosePage> {
  DateTime selectedDate = DateTime.now();
  TextEditingController _eventController = new TextEditingController();
  Filiere _filiere = null;
  Niveau _niveau = null;
Section _section = null;
  String _events;


  @override
  void initState() {
    super.initState();
    _eventController = TextEditingController();
    _events = "";



  }
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Choisir section & niveau '),
        ),

        body: new Container(
            child: new Column(
              children: <Widget>[

                //filiere

                //separator//
                new Padding(
                  padding: new EdgeInsets.all(8.0),
                ),
              // new Divider(height: 5.0, color: Colors.black),
                new Padding(
                  padding: new EdgeInsets.all(8.0),
                ),


                new Text(
                  'Filière :',
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Radio(
                      value: Filiere.info,
                      groupValue: _filiere,
                      onChanged: (Filiere value) {
                        setState(() {
                          _filiere = value;
                        });
                      },
                    ),


                    new Text(
                      'Informatique',
                      style: new TextStyle(fontSize: 16.0),
                    ),
                    new Radio(
                      value: Filiere.civil,
                      groupValue: _filiere,
                      onChanged: (Filiere value) {
                        setState(() {
                          _filiere = value;
                        });
                      },
                    ),
                    new Text(
                      'Civil',
                      style: new TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    new Radio(
                      value: Filiere.electrique,
                      groupValue: _filiere,
                      onChanged: (Filiere value) {
                                  setState(() {
                                    _filiere = value;
                                  });
                                },
                    ),
                    new Text(
                      'Electrique',
                      style: new TextStyle(fontSize: 16.0),
                    ),

                  ],
                ),


                //niveau

                //separator//
                new Padding(
                  padding: new EdgeInsets.all(8.0),
                ),
                 new Divider(height: 5.0, color: Colors.black),
                new Padding(
                  padding: new EdgeInsets.all(8.0),
                ),


                new Text(
                  'Niveau :',
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Radio(
                      value: Niveau.G1,
                      groupValue: _niveau,
                      onChanged: (Niveau value) {
                        setState(() {
                          _niveau = value;
                        });
                      },
                    ),


                    new Text(
                      '1ere',
                      style: new TextStyle(fontSize: 16.0),
                    ),
                    new Radio(
                      value: Niveau.G2,
                      groupValue: _niveau,
                      onChanged: (Niveau value) {
                        setState(() {
                          _niveau = value;
                        });
                      },
                    ),
                    new Text(
                      '2ème',
                      style: new TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    new Radio(
                      value: Niveau.G3,
                      groupValue: _niveau,
                      onChanged: (Niveau value) {
                        setState(() {
                          _niveau = value;
                        });
                      },
                    ),
                    new Text(
                      '3ème',
                      style: new TextStyle(fontSize: 16.0),
                    ),

                  ],
                ),

                //section

                //separator//
                new Padding(
                  padding: new EdgeInsets.all(8.0),
                ),
                new Divider(height: 5.0, color: Colors.black),
                new Padding(
                  padding: new EdgeInsets.all(8.0),
                ),


                new Text(
                  'Section :',
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Radio(
                      value: Section.S1,
                      groupValue: _section,
                      onChanged: (Section value) {
                        setState(() {
                          _section = value;
                        });
                      },
                    ),


                    new Text(
                      'S1',
                      style: new TextStyle(fontSize: 16.0),
                    ),
                    new Radio(
                      value: Section.S2,
                      groupValue: _section,
                      onChanged: (Section value) {
                        setState(() {
                          _section = value;
                        });
                      },
                    ),


                    new Text(
                      'S2',
                      style: new TextStyle(fontSize: 16.0),
                    ),
                    new Radio(
                      value: Section.S3,
                      groupValue: _section,
                      onChanged: (Section value) {
                        setState(() {
                          _section = value;
                        });
                      },
                    ),


                    new Text(
                      'S3',
                      style: new TextStyle(fontSize: 16.0),
                    ),
                    new Radio(
                      value: Section.S4,
                      groupValue: _section,
                      onChanged: (Section value) {
                        setState(() {
                          _section = value;
                        });
                      },
                    ),


                    new Text(
                      'S4',
                      style: new TextStyle(fontSize: 16.0),
                    ),

                  ],
                ),
              Text("\n\n\n\n"),
                RaisedButton(
                  onPressed:
                    _showAddDialog,



                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xFF0D47A1),
                          Color(0xFF1976D2),
                          Color(0xFF0D47A1),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child:
                    const Text('Ajouter notes', style: TextStyle(fontSize: 20)),
                  ),
                ),



              ],



    ),
    )
    );
  }




  _showAddDialog() {
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              content:
              TextField(
                controller: _eventController,
              ),
              actions: <Widget>[
                RaisedButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Select date'),
                ),
                FlatButton(
                  child: Text("Save"),
                  onPressed: () async {

                    final FirebaseUser currentUser= await Provider.of<AuthService>(context).getUser();
                    if(_niveau.toString()=="Niveau.G1"){
                      if(_section.toString()=="Section.S1"){
                        await Databaseservice(currentUser.uid).ProfaddnoteGI1S1(currentUser.email,_eventController.text,"${selectedDate.toLocal()}".split(' ')[0]);


                      }
                      else if(_section.toString()=="Section.S2"){
                        await Databaseservice(currentUser.uid).ProfaddnoteGI1S2(currentUser.email,_eventController.text);
                      }
                    }

                      Navigator.pop(context);
                    //  _eventController.clear();





                  },
                ),

              ],
            )
    );
  }


}


