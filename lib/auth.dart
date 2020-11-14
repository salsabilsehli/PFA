import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;





  Future<String> getCurrentUID() async {
    return (await _auth.currentUser()).uid;
  }
  ///
  /// return the Future with firebase user object FirebaseUser if one exists
  ///
  Future<FirebaseUser> getUser() {
    return _auth.currentUser();
  }

  // wrapping the firebase calls
  Future logout() async {
    var result = FirebaseAuth.instance.signOut();
    notifyListeners();
    return result;
  }

  // wrapping the firebase calls
  Future createUser(
      {String firstName,
        String lastName,
        String email,
        String password}) async {
    var result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    UserUpdateInfo info = UserUpdateInfo();
    info.displayName = '$firstName $lastName';
    return await result.updateProfile(info);
  }

  ///
  /// wrapping the firebase call to signInWithEmailAndPassword
  /// `email` String
  /// `password` String
  ///
  Future<FirebaseUser> loginUser({String email, String password}) async {
    try {
      var result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // since something changed, let's notify the listeners...
      notifyListeners();

      return result;
    }  catch (e) {
      throw new AuthException(e.code, e.message);
    }
  }

}
