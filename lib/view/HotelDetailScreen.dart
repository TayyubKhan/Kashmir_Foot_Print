// ignore_for_file: use_build_context_synchronously

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Google Map/Google Map.dart';
import '../Google Map/Places.dart';
import '../Utilis/Call.dart';
import '../Utilis/colors.dart';

class HotelsDetailScreen extends StatefulWidget {
  final List<dynamic> details;
  final int index;
  const HotelsDetailScreen(
      {super.key, required this.details, required this.index});

  @override
  State<HotelsDetailScreen> createState() => _HotelsDetailScreenState();
}

class _HotelsDetailScreenState extends State<HotelsDetailScreen> {
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
        title: const Text('Hotels'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: height * 0.1,
            ),
            CarouselSlider(
              options: CarouselOptions(
                height: height * 0.4,
                enlargeCenterPage:
                    true, // Set to true if you want the center image to be larger
                autoPlay: true, // Set to true for auto-playing the carousel
                autoPlayInterval: const Duration(seconds: 2),
              ),
              items: [
                widget.details[widget.index]['image0']['path'],
                widget.details[widget.index]['image1']['path'],
                widget.details[widget.index]['image2']['path'],
                widget.details[widget.index]['image3']['path'],
                widget.details[widget.index]['image4']['path']
              ].map((imageUrl) {
                return Builder(
                  builder: (BuildContext context) {
                    return ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          imageUrl,
                          height: height * 0.5,
                          fit: BoxFit.fill,
                        ));
                  },
                );
              }).toList(),
            ),
            SizedBox(
              height: height * 0.05,
            ),
            Text(
              widget.details[widget.index]['name'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: width * 0.1,
                            height: width * 0.1,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey.withOpacity(0.2)),
                            child: const Center(
                              child: Icon(Icons.access_time_sharp, color: back),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.02,
                          ),
                          Column(
                            children: [
                              const Text('Duration',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.grey)),
                              Text(
                                  widget.details[widget.index]['duration']
                                      .toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: width * 0.1,
                            height: width * 0.1,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.withOpacity(0.2)),
                            child: const Center(
                              child: Text('Rs',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: back)),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.02,
                          ),
                          Column(
                            children: [
                              const Text('Price',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.grey)),
                              Text(
                                  'Rs ${widget.details[widget.index]['price']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Container(
              height: height * 0.1,
              width: width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      child: const Icon(Icons.person_2_outlined,
                          color: Colors.blue),
                    ),
                    InkWell(
                      onTap: () async {
                        LatLng latLang = await getCoordinates(
                            '${widget.details[widget.index]['name']}Azad Kashmir');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AppGoogleMap(latLang: latLang)));
                      },
                      child: Text(
                        widget.details[widget.index]['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          Calland_message().makePhoneCall(
                              widget.details[widget.index]['phone Number']
                                ..toString());
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.message_outlined,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: width * 0.02,
                            ),
                            const Icon(
                              Icons.phone,
                              color: Colors.blue,
                            )
                          ],
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
