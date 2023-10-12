// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/view/HomeScreen.dart';
import 'package:myapp/view/signupLogin.dart';

import '../adminScreens/AdminHomeScreen.dart';

class SplashServices {
  final fireStore = FirebaseFirestore.instance.collection('users');
  void isLogin(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      final user = await fireStore.doc(auth.currentUser!.uid).get();
      if (user['role'] == 'admin') {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AdminHomeScreen()));
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SignUpLoginScreen()));
    }
  }
}
