// ignore_for_file: use_build_context_synchronously

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Google Map/Google Map.dart';
import '../Google Map/Places.dart';
import '../Utilis/colors.dart';

class PlacesDetailScreen extends StatefulWidget {
  final List<dynamic> details;
  final int index;
  const PlacesDetailScreen(
      {super.key, required this.details, required this.index});

  @override
  State<PlacesDetailScreen> createState() => _PlacesDetailScreenState();
}

class _PlacesDetailScreenState extends State<PlacesDetailScreen> {
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
        title: const Text('Places'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                          fit: BoxFit.cover,
                        ));
                  },
                );
              }).toList(),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            InkWell(
              onTap: () async {
                LatLng latLang = await getCoordinates(
                  widget.details[widget.index]['location'] +
                      widget.details[widget.index]['district'],
                );
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AppGoogleMap(latLang: latLang)));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on_outlined, color: back),
                  Text(widget.details[widget.index]['location'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 30)),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Container(
              width: width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black54)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                    textAlign: TextAlign.center,
                    widget.details[widget.index]['description'].toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20)),
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            const Text('Activities to do',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff88908E),
                    fontSize: 20)),
            SizedBox(
              height: height * 0.01,
            ),
            Container(
              width: width,
              height: height * 0.07,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black54)),
              child: Center(
                child: Text(widget.details[widget.index]['todo'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
