import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:myapp/view/Setting%20Screen.dart';
import 'package:provider/provider.dart';

import 'Model.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Dark_mode_Provider()),
        ],
        child: Builder(builder: (BuildContext context) {
          final themechanger = Provider.of<Dark_mode_Provider>(context);
          return MaterialApp(
              title: 'Flutter Demo',
              themeMode: themechanger.thememode,
              darkTheme: ThemeData(
                appBarTheme: const AppBarTheme(backgroundColor: Colors.black26),
                brightness: Brightness.dark,
              ),
              theme: ThemeData(
                brightness: Brightness.light,
                primarySwatch: Colors.pink,
              ),
              home: const SettingScreen());
        }));
  }
}
