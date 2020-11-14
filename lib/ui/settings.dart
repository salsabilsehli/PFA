import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

Function themer;

class SettingsPage extends StatefulWidget {
  final FirebaseUser currentUser;
  SettingsPage(Function themerCallback,this.currentUser) {
    themer = themerCallback;
  }

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  String _currentTheme = 'Light';
  String _currentPrimarySwatch = 'Blue';
  bool _disablePrimarySwatchPreference = true;
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    getDefaults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Default Settings'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 12, right: 12),
          child: Column(
            children: <Widget>[

              DropdownButtonFormField(
                items: [
                  DropdownMenuItem(
                    child: Text('Light'),
                    value: 'Light',
                  ),
                  DropdownMenuItem(
                    child: Text('Dark'),
                    value: 'Dark',
                  ),
                ],
                value: _currentTheme,
                decoration: InputDecoration(labelText: 'Theme'),
                onChanged: (v) {
                  setState(() {
                    _currentTheme = v;
                    _disablePrimarySwatchPreference = _currentTheme == 'Dark';
                  });
                  setTheme();
                  themer(_currentTheme, _currentPrimarySwatch);
                },
              ),
              _disablePrimarySwatchPreference
                  ? Container()
                  : DropdownButtonFormField(
                items: [
                  DropdownMenuItem(
                    child: Text('Blue'),
                    value: 'Blue',
                  ),
                  DropdownMenuItem(
                    child: Text('Indigo'),
                    value: 'Indigo',
                  ),
                  DropdownMenuItem(
                    child: Text('Cyan'),
                    value: 'Cyan',
                  ),
                  DropdownMenuItem(
                    child: Text('Light Blue'),
                    value: 'Light Blue',
                  ),
                  DropdownMenuItem(
                    child: Text('Light Green'),
                    value: 'Light Green',
                  ),
                  DropdownMenuItem(
                    child: Text('Teal'),
                    value: 'Teal',
                  ),
                  DropdownMenuItem(
                    child: Text('Red'),
                    value: 'Red',
                  ),
                  DropdownMenuItem(
                    child: Text('Green'),
                    value: 'Green',
                  ),
                  DropdownMenuItem(
                    child: Text('Yellow'),
                    value: 'Yellow',
                  ),
                  DropdownMenuItem(
                    child: Text('Lime'),
                    value: 'Lime',
                  ),
                  DropdownMenuItem(
                    child: Text('Amber'),
                    value: 'Amber',
                  ),
                  DropdownMenuItem(
                    child: Text('Orange'),
                    value: 'Orange',
                  ),
                  DropdownMenuItem(
                    child: Text('Deep Orange'),
                    value: 'Deep Orange',
                  ),
                  DropdownMenuItem(
                    child: Text('Purple'),
                    value: 'Purple',
                  ),
                  DropdownMenuItem(
                    child: Text('Deep Purple'),
                    value: 'Deep Purple',
                  ),
                  DropdownMenuItem(
                    child: Text('Brown'),
                    value: 'Brown',
                  ),
                  DropdownMenuItem(
                    child: Text('Pink'),
                    value: 'Pink',
                  ),
                ],
                value: _currentPrimarySwatch,
                decoration: InputDecoration(labelText: 'Primary Color'),
                onChanged: (v) {
                  setState(() {
                    _currentPrimarySwatch = v;
                  });
                  setPrimarySwatch();
                  themer(_currentTheme, _currentPrimarySwatch);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getDefaults() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {

      _currentTheme = sharedPreferences.getString('theme') ?? 'Light';
      _currentPrimarySwatch =
          sharedPreferences.getString('primarySwatch') ?? 'Blue';
      _disablePrimarySwatchPreference = _currentTheme == 'Light';
    });
  }



  void setTheme() async {
    sharedPreferences.setString('theme', _currentTheme);
  }

  void setPrimarySwatch() async {
    sharedPreferences.setString('primarySwatch', _currentPrimarySwatch);
  }
}