import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/view/signupLogin.dart';
import 'package:provider/provider.dart';

import '../Model.dart';
import '../Utilis/colors.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  int value = 0;

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
            ),
            ListTile(
              title: const Text('Theme'),
              trailing: Consumer<Dark_mode_Provider>(
                  builder: (context, thememode, child) {
                return value == 0
                    ? InkWell(
                        onTap: () {
                          value = 1;
                          thememode.settheme(ThemeMode.dark);
                        },
                        child: const Icon(Icons.dark_mode_outlined))
                    : InkWell(
                        onTap: () {
                          value = 0;
                          thememode.settheme(ThemeMode.light);
                        },
                        child: const Icon(Icons.light_mode_outlined));
              }),
            ),
            ListTile(
              onTap: () {
                // auth.signOut().then((value) {
                //   Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => const SignUpLoginScreen()));
                // });
              },
              title: const Text(
                'About Us',
              ),
              trailing: const Icon(Icons.perm_device_info),
            ),
          ],
        ));
  }
}
