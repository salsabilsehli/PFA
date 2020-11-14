import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hello_world/ui/ChoosePage.dart';

class Databaseservice {

  //final FirebaseUser currentUser;

  final CollectionReference EtudiantsGI1S1Collection = Firestore.instance.collection(
      "Etudiants").document("GI1").collection("S1");
  final CollectionReference EtudiantsGI1S2Collection = Firestore.instance.collection(
      "Etudiants").document("GI1").collection("S2");
  final CollectionReference NoteProfGI1S1Collection = Firestore.instance
      .collection(
      "Etudiants").document("GI1").collection("S1")
      .document("Notes des profs")
      .collection("notes de profs");
  final CollectionReference NoteProfGI1S2Collection = Firestore.instance
      .collection(
      "Etudiants").document("GI1").collection("S2")
      .document("Notes des profs")
      .collection("notes de profs");
  final CollectionReference MessagesGI1S1Collection = Firestore.instance.collection("MessagesGI1S1");
  final String uid;

  Databaseservice(this.uid);


//add notes persos
  Future addnoteGI1S1(String noteEt) async {
    return await EtudiantsGI1S1Collection.document(uid).collection("notes perso").add({
      'notes personnelles': noteEt
    });
  }
  Future addnoteGI1S2(String noteEt) async {
    return await EtudiantsGI1S2Collection.document(uid).collection("notes perso").add({
      'notes personnelles': noteEt
    });
  }

  //add notes prof

  Future ProfaddnoteGI1S1(String email, String noteP,String date) async {

    return await NoteProfGI1S1Collection.add({
      email: noteP,
      "date" : date
    }
    );

    }
  Future ProfaddnoteGI1S2(String email, String noteP) async {

    return await NoteProfGI1S2Collection.add({
      email: noteP
    }

    );
  }
  Future ProfsendnotifGI1S1(String text,String notifP) async {

    return await MessagesGI1S1Collection.document(text).setData({
      text: notifP
    }



    );
  }
  Future nomsprenomendnotiflihGI1S1(String text,String notif) async {

    return await Firestore.instance.collection("nomprenomProfGI1S1").document(text).setData({
      text: notif
    });




  }




 /* String getnote() {
    EtudiantsCollection.document(uid).get().then((value) {
      return (value.data);
    });
  }*/
}
