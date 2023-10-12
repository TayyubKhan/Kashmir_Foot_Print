import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/view/signupLogin.dart';

import '../Utilis/colors.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: back,
            ),
          ),
          title: const Text(
            'Setting',
            style: TextStyle(color: back),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            ListTile(
              onTap: () {
                auth.signOut().then((value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpLoginScreen()));
                });
              },
              title: const Text(
                'Logout',
              ),
              trailing: const Icon(Icons.exit_to_app),
            )
          ],
        ));
  }
}
