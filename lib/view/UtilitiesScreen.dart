import 'package:flutter/material.dart';
import 'package:myapp/Components/Button.dart';
import 'package:myapp/view/CarRental.dart';
import 'package:myapp/view/Hospitals.dart';
import 'package:myapp/view/HotelsScreen.dart';
import 'package:myapp/view/Mechanical%20Help.dart';

import '../Utilis/colors.dart';
import 'TouristPolice.dart';

class UtilitiesScreen extends StatefulWidget {
  const UtilitiesScreen({super.key});

  @override
  State<UtilitiesScreen> createState() => _UtilitiesScreenState();
}

class _UtilitiesScreenState extends State<UtilitiesScreen> {
  List<String> images = [
    'images/hospital.png',
    'images/hotel.png',
    'images/mech.png',
    'images/police.png',
    'images/rent.png',
  ];
  List<String> name = [
    'Hospitals',
    'Hotels',
    'Mechanical Help',
    'Tourist Police',
    'Car Rental',
  ];
  List<Widget> screens = const [
    HospitalScreen(),
    HotelScreen(),
    MechanicalScreen(),
    TouristPolice(),
    CarRental(),
  ];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
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
          'Utilities',
          style: TextStyle(color: back),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: name.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Image(
                            height: height * 0.2,
                            width: width * 0.8,
                            fit: BoxFit.fill,
                            image: AssetImage(images[index])),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        AppButton(
                            text: name[index],
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => screens[index]));
                            })
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
