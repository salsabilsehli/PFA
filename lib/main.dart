import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hello_world/ui/ScheduleProf.dart';
import 'package:flutter_hello_world/ui/AllNotifications.dart';
import 'package:flutter_hello_world/ui/settings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/themes.dart';
import 'ui/Schedule.dart';
import 'ui/Reminder.dart';
import 'auth.dart';
import 'login_page.dart';

void main() => runApp(
  ChangeNotifierProvider<AuthService>(
    child: MyApp(),
    builder: (BuildContext context) {
      return AuthService();

    },
  ),

);

class MyApp extends StatefulWidget {
  final FirebaseUser currentUser;

  const MyApp({Key key, this.currentUser}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState(currentUser);
}

class _MyAppState extends State<MyApp> {
  final FirebaseUser currentUser;
  Brightness _theme;
  Color _primarySwatch;

  _MyAppState(this.currentUser);





  @override
  void initState() {
    super.initState();
    getDefaults();

  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "StudTime",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: _theme,
        primarySwatch: _primarySwatch,
      ),

      initialRoute: '/',
      routes: {
        '/Etud/settings': (context) => SettingsPage(this.themer,currentUser),
        '/Etud/Reminder' : (context) => ReminderPage(currentUser),

      },
      home:
      FutureBuilder<FirebaseUser>(
        future: Provider.of<AuthService>(context).getUser(),
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // log error to console
            if (snapshot.error != null) {
              print("error");
              return Text(snapshot.error.toString());
            }

            // redirect to the proper page

            if(snapshot.hasData) {
              if (snapshot.data.email.endsWith("@stud.enis.tn")) {
                return
                  //AllNotifications(currentUser);
                  SchedulePage(snapshot.data);
              }
              else if (snapshot.data.email.endsWith("@enis.tn")) {
                return
                  ScheduleProfPage(snapshot.data);
              }
            }
            else {
              return LoginPage();
            }

            // return snapshot.hasData ? HomePageProf(snapshot.data) : LoginPage();




          }


            // show loading indicator
            return LoadingCircle();


        },

      ),

    );
  }

  void getDefaults() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _theme = appTheme[sharedPreferences.getString('theme') ?? 'Dark'];
      _primarySwatch = primarySwatchThemes[
      sharedPreferences.getString('primarySwatch') ?? 'Blue'];
    });
  }

  void themer(String theme, String primarySwatch) {
    setState(() {
      _theme = appTheme[theme];
      _primarySwatch = primarySwatchThemes[primarySwatch];
    });
  }
}
class LoadingCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: CircularProgressIndicator(),
        alignment: Alignment(0.0, 0.0),
      ),
    );
  }
}
