import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Utilis/colors.dart';
import 'package:myapp/adminScreens/AddHospital.dart';
import 'package:myapp/adminScreens/AddHotels.dart';
import 'package:myapp/adminScreens/Notifications.dart';
import 'package:myapp/adminScreens/addMechanic.dart';
import 'package:myapp/adminScreens/carRental.dart';
import 'package:myapp/view/splashscreen.dart';

import 'AddPlaces.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final auth = FirebaseAuth.instance;
  List<Widget> screen = [
    const AddPlaces(),
    const AddHospitals(),
    const AddCarRental(),
    const AddHotels(),
    const MechanicalDetails(),
    const AdminNotifications(),
  ];
  List<String> screenName = [
    'Add Places',
    'Add Hospitals',
    'Add CarRental',
    'Add Hotels',
    'Add Mechanic',
    'Add Notification'
  ];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return WillPopScope(
      onWillPop: () async {
        // Return true to allow back navigation, or false to disable it
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Admin',
            style: TextStyle(color: back),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: InkWell(
                onTap: () {
                  auth.signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SplashScreen()));
                },
                child: const Icon(
                  Icons.exit_to_app,
                  color: back,
                ),
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: GridView.builder(
                  itemCount: 6,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 4,
                  ),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => screen[index]));
                        },
                        child: Container(
                            width: width * 0.3,
                            height: height * 0.3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(35),
                                border: Border.all(color: back)),
                            child: Center(
                              child: Text(
                                screenName[index],
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 31),
                              ),
                            )),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
