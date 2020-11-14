import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hello_world/auth.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:math';

class AllNotifications extends StatefulWidget {

  final FirebaseUser currentUser;
  AllNotifications(this.currentUser);

  @override
  State<StatefulWidget> createState() => _AllNotificationsState();
}

class _AllNotificationsState extends State<AllNotifications> {
  List<String> list =[];

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  CollectionReference NotifGI1S1 = Firestore.instance.collection(
      "MessagesGI1S1");

  @override
  void initState() {
    super.initState();
    //_configureFirebaseListeners();
    NotifGI1S1.getDocuments().then((querySnapshot) {
      querySnapshot.documents.forEach((result) {
        list.add(result.data.values.toString());
      });
    });
    refreshList();
    //messagesList = List<String>();
  }

  //List<String> messagesList;
  Future<Null> refreshList() async {


    setState(() {

      NotifGI1S1.getDocuments().then((querySnapshot) {
        querySnapshot.documents.forEach((result) {
          if(list.contains(result.data.values.toString())){
            return ;
          }
          else{
            list.add(result.data.values.toString());
          }



        });});


      return null;
    });
  }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Toute les notifs des profs"),
        ),
        body: RefreshIndicator(
          key: refreshKey,
          child: ListView.builder(
            itemCount: list?.length,
            itemBuilder: (BuildContext context, int i) {
              return Card( //                           <-- Card widget
                  child: ListTile(
                    title: Text(list[i]),
                  ));
            }
                //new Text(list[i]);}
          ),
          onRefresh: refreshList,
        ),
      );
    }

  }