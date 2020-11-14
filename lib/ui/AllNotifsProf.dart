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

class AllNotifsProf extends StatefulWidget {

  final FirebaseUser currentUser;
  AllNotifsProf(this.currentUser);

  @override
  State<StatefulWidget> createState() => _AllNotifsProfState();
}

class _AllNotifsProfState extends State<AllNotifsProf> {
  List<String> list =[];

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  CollectionReference nomprenomProfGI1S1 = Firestore.instance.collection(
      "nomprenomProfGI1S1");
   CollectionReference MessagesGI1S1Collection = Firestore.instance.collection("MessagesGI1S1");

  @override
  void initState() {
    super.initState();

    refreshList();
    //messagesList = List<String>();
  }

  //List<String> messagesList;
  Future<Null> refreshList() async {
    final FirebaseUser currentUser= await Provider.of<AuthService>(context).getUser();


    setState(() {
      if (currentUser.email == "nom.prenom@enis.tn"){
        nomprenomProfGI1S1.getDocuments().then((querySnapshot) {
          querySnapshot.documents.forEach((result) {
            if (list.contains(result.data.values.toString())) {
              return;
            }
            else {
              list.add(result.data.values.toString());
            }
          });
        });


      return null;
    }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pull to refresh"),
      ),

      body: RefreshIndicator(
        key: refreshKey,
        child: ListView.builder(
            itemCount: list?.length,
            itemBuilder: (BuildContext context, int i) {
              return Dismissible(
                key : Key(list[i]),
               child :
               Card( //                           <-- Card widget
                  child: ListTile(
                    title: Text(list[i]),
                    trailing: IconButton(icon: Icon(Icons.delete),color: Colors.red,
                    onPressed: () async{


                        final FirebaseUser currentUser= await Provider.of<AuthService>(context).getUser();
                          if (currentUser.email == "nom.prenom@enis.tn") {
                           nomprenomProfGI1S1
                                .document(currentUser.uid+list[i])
                                .delete();



                           /* MessagesGI1S1Collection
                                .document(currentUser.uid + list[i])
                                .delete();*/
                            //list.remove(list[i]);
setState(() {
  list.removeAt(i);

});



                          }

                    },


                    ),


                  ),)
              ); }
          //new Text(list[i]);}
        ),
        onRefresh: refreshList,
      ),
    );
  }

}