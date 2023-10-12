// ignore_for_file: use_build_context_synchronously

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myapp/Utilis/colors.dart';
import 'package:myapp/view/Places%20Detail.dart';

import '../Google Map/Google Map.dart';
import '../Google Map/Places.dart';
import '../Utilis/Call.dart';

class MechanicalScreen extends StatefulWidget {
  const MechanicalScreen({super.key});
  @override
  State<MechanicalScreen> createState() => _MechanicalScreenState();
}

class _MechanicalScreenState extends State<MechanicalScreen> {
  final ref = FirebaseDatabase.instance.ref('mechanic');
  FirebaseAuth auth = FirebaseAuth.instance;
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
          'Mechanical Help',
          style: TextStyle(color: back),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Expanded(
                  child: StreamBuilder(
                stream: ref.onValue,
                builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    // Handle Firebase-specific errors
                    return Center(
                      child: Text('Error: ${snapshot.error.toString()}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    // Handle case where no data is available
                    return const Center(
                      child: Text('No data available.'),
                    );
                  } else {
                    try {
                      Map<dynamic, dynamic> map =
                          snapshot.data!.snapshot.value as dynamic;
                      List<dynamic> list = [];
                      list.clear();
                      list = map.values.toList();
                      print(list.length);
                      return ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(15),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PlacesDetailScreen(
                                                details: list, index: index)));
                              },
                              child: Column(
                                children: [
                                  CarouselSlider(
                                    options: CarouselOptions(
                                      height: height * 0.4,
                                      enlargeCenterPage:
                                          true, // Set to true if you want the center image to be larger
                                      autoPlay:
                                          true, // Set to true for auto-playing the carousel
                                      autoPlayInterval:
                                          const Duration(seconds: 2),
                                    ),
                                    items: [
                                      list[index]['image0']['path'],
                                      list[index]['image1']['path'],
                                      list[index]['image2']['path'],
                                      list[index]['image3']['path'],
                                      list[index]['image4']['path']
                                    ].map((imageUrl) {
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: Image.network(
                                                imageUrl,
                                                height: height * 0.2,
                                                fit: BoxFit.fill,
                                              ));
                                        },
                                      );
                                    }).toList(),
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    width: width,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border:
                                            Border.all(color: Colors.black12)),
                                    child: Column(
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              list[index]['name'],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            const Text('4.5'),
                                            SizedBox(
                                              width: width * 0.1,
                                            ),
                                            const Icon(Icons.star,
                                                color: Colors.yellow)
                                          ],
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            LatLng latLang =
                                                await getCoordinates(
                                              list[index]['name'] +
                                                  list[index]['location'],
                                            );
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AppGoogleMap(
                                                            latLang: latLang)));
                                          },
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.location_on_outlined,
                                                color: back,
                                              ),
                                              Text(
                                                list[index]['location'],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(3.0),
                                          child: Divider(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                    Icons.access_time_rounded,
                                                    color: back),
                                                SizedBox(
                                                  width: width * 0.02,
                                                ),
                                                const Text(
                                                  'Open 24 Hours',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: height * 0.02,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Calland_message().makePhoneCall(
                                                    list[index]['phone Number']
                                                        .toString());
                                              },
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.phone,
                                                      color: CupertinoColors
                                                          .systemBlue),
                                                  SizedBox(
                                                    width: width * 0.02,
                                                  ),
                                                  Text(
                                                    list[index]['phone Number'],
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } catch (e) {
                      // Handle any unexpected exceptions that might occur while processing the data
                      return Center(
                        child: Text('An error occurred: $e'),
                      );
                    }
                  }
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}
