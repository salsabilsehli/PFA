import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hello_world/ui/Reminder.dart';
import 'package:provider/provider.dart';
import 'auth.dart';
import 'package:email_validator/email_validator.dart';

import 'ui/Schedule.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}
enum SingingCharacter { Student, Teacher ,zero}

class _LoginPageState extends State<LoginPage> {
  AssetImage _imageToShow;
  final _formKey = GlobalKey<FormState>();
  String _password;
  String _email;
  SingingCharacter _character = SingingCharacter.zero;


  @override
  void initState() {
    _imageToShow = AssetImage('assets/images/account.png');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: SizedBox(
            width: double.infinity,
            child: Container(
              child: Text(
                "LOGIN",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20,),
              ),
            ),
          ),

        ),
        body:
        Container(


            child:

            Form(

                key: _formKey,
                child: Column(children: <Widget>[
                  SizedBox(height: 20.0),

                  Column(
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          child: Text(
                            "vous etes :",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),


                  SizedBox(height: 20.0),

                  ListTile(
                    title: const Text('Etudiant'),
                    leading: Radio(
                      value: SingingCharacter.Student,

                      groupValue: _character,
                      onChanged: (SingingCharacter value) {
                        setState(() {
                          _character = value;
                          _imageToShow = new AssetImage('assets/images/student.png');


                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Enseignant'),
                    leading: Radio(
                      value: SingingCharacter.Teacher,
                      groupValue: _character,
                      onChanged: (SingingCharacter value) {
                        setState(() {
                          _character = value;
                          _imageToShow = new AssetImage('assets/images/teacher.png');
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 50.0),

                  Container(

                    padding: EdgeInsets.all(20.0),
                    height: 150.0,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: _imageToShow,
                      ),
                    ),
                  ),
                  TextFormField(
                      validator: (value){

                        final bool isValid = EmailValidator.validate(value);
                        print('Email is valid?' +(isValid ? 'yes' : 'no'));


                        if((value.endsWith("@gmail.com"))||(value.endsWith("@gmail.fr")) ||(value.endsWith("ieee.org")) ||(value.endsWith("yahoo.com")) || (value.endsWith("yahoo.fr"))){
                          return " l'e-mail doit etre de l 'Enis !";
                        }
                        if(value.isEmpty){
                          return"Le champs e-mail est vide !";
                        }},
                      onSaved: (value) => _email = value,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: "Adresse email ")),
                  TextFormField(
                      validator: (val){
                        if(val.isEmpty){
                          return"Le champs mot de passe est vide !";
                        }
                        if((val.length<8) || (val.length>8) ){
                          return "Il faut entrer votre Num CIN !";
                        }
                      },
                      onSaved: (value) => _password = value,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      obscureText: true,
                      decoration: InputDecoration(labelText: "Mot de passe")),

                  SizedBox(height: 20.0),
                  RaisedButton(
                    child: Text("LOGIN",),
                    onPressed: () async {
                      // save the fields..
                      final form = _formKey.currentState;
                      form.save();

                      // Validate will return true if is valid, or false if invalid.
                      if (form.validate()) {
                        try {
                          FirebaseUser result =
                          await Provider.of<AuthService>(context).loginUser(
                              email: _email, password: _password);

                          print(result);
                        } on AuthException catch (error) {
                          return _buildErrorDialog(context, error.message);
                        } on Exception catch (error) {
                          return _buildErrorDialog(context, error.toString());
                        }
                      }
                    },
                  )
                ])) //form



        )//container
    ); //scaffold
  }

  Future _buildErrorDialog(BuildContext context, _message) {
    return showDialog(
      builder: (context) {
        return AlertDialog(
          title: Text('Erreur !'),
          content: Text("Vérifier les informations saisies !"),
          actions: <Widget>[
            FlatButton(
                child: Text('ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      },
      context: context,
    );
  }
}
