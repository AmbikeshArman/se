import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class Functions {
  Future<String> register(String email, String password) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return 'true';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> signin(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return 'true';
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  Future<String> admin(String email) async {
    var resp = await FirebaseFirestore.instance.collection('admin').get();
    for (int i = 0; i < resp.docs.length; i++) {
      if (resp.docs[i]['email'] == email) {
        return "Admin";
      }
    }
    return "";
  }
}
