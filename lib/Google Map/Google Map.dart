import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart'
    hide TravelMode, Polyline;
import 'package:google_maps_webservice/directions.dart' as t;
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../Utilis/colors.dart';
import 'Places.dart';

class AppGoogleMap extends StatefulWidget {
  final LatLng latLang;

  const AppGoogleMap({super.key, required this.latLang});

  @override
  State<AppGoogleMap> createState() => _AppGoogleMapState();
}

class _AppGoogleMapState extends State<AppGoogleMap> {
  Future<Position?> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print(position);
      return position;
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  String time = '';
  String distance = '';
  Future<void> getTime(LatLng startlatlng, LatLng destlatlng) async {
    final directions =
        GoogleMapsDirections(apiKey: 'AIzaSyBrDLtzgJD3h1MibAYXbuJPBOIQrq3rfKY');
    DirectionsResponse response = await directions.directions(
      Location(
          lat: startlatlng.latitude,
          lng: startlatlng.longitude), // Starting LatLng
      Location(
          lat: destlatlng.latitude, lng: destlatlng.longitude), // Ending LatLng
      travelMode: t.TravelMode.driving,
    );

    if (response.isOkay) {
      t.Route route = response.routes[0];
      distance = route.legs[0].distance.text;
      time = route.legs[0].duration.text;
      print('Distance: ${route.legs[0].distance.text}');
      print('Time: ${route.legs[0].duration.text}');
    } else {
      print('Error: ${response.errorMessage}');
    }
  }

  Future<void> _addMarkers(LatLng startlatlng, LatLng destlatlng) async {
    _markers.add(Marker(
      markerId: const MarkerId('start'),
      position: startlatlng,
      infoWindow: const InfoWindow(title: 'Start'),
    ));

    _markers.add(Marker(
      markerId: const MarkerId('dest'),
      position: destlatlng,
      infoWindow: const InfoWindow(title: 'Destination'),
    ));
  }

  Future<void> _getPolylines(LatLng startlatlng, LatLng destlatlng) async {
    try {
      PolylinePoints polylinePoints = PolylinePoints();
      List<LatLng> polylineCoordinates = [];
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyBrDLtzgJD3h1MibAYXbuJPBOIQrq3rfKY",
        PointLatLng(startlatlng.latitude, startlatlng.longitude),
        PointLatLng(destlatlng.latitude, destlatlng.longitude),
        travelMode: TravelMode.driving,
      );

      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      }
      _polylines.add(
        Polyline(
          width: 4,
          polylineId: const PolylineId('route1'),
          color: back,
          points: polylineCoordinates,
        ),
      );
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  List<dynamic> places = [];
  List<dynamic> suggested = [];
  final Completer<GoogleMapController> _controller = Completer();
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  String _sessionToken = '12345';
  var uuid = const Uuid().v4();
  final Completer<GoogleMapController> _googleMapController = Completer();
  List<Marker> markers = [];
  late CameraPosition _kGoogleMap;
  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      onChange();
    });
    final List<Marker> list = [
      Marker(markerId: const MarkerId('1'), position: widget.latLang),
    ];
    _kGoogleMap = CameraPosition(target: widget.latLang, zoom: 16);

    markers.addAll(list);
  }

  void onChange() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid;
      });
    } else {
      getSuggestions(controller.text);
    }
  }

  bool showContain = false;
  void getSuggestions(String input) async {
    String kPLACES_API_KEY = 'AIzaSyC4QfSfNEEmdiT9Jrh5xjmqczEN8CAg4Os';
    String baseURL =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json";
    String request =
        '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';
    var response = await http.get(Uri.parse(request));
    if (kDebugMode) {
      print(response.body.toString());
    }
    if (response.statusCode == 200) {
      setState(() {
        places = jsonDecode(response.body.toString())['predictions'];
      });
    } else {
      throw Exception('failed');
    }
  }

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: const Icon(
            Icons.location_on,
            color: back,
          ),
          onPressed: () async {
            GoogleMapController googleController =
                await _googleMapController.future;
            googleController.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(target: widget.latLang, zoom: 14)));
            setState(() {});
          },
        ),
        body: Stack(
          children: [
            GoogleMap(
              polylines: _polylines,
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              rotateGesturesEnabled: true,
              compassEnabled: true,
              initialCameraPosition:
                  _kGoogleMap, // Use the initialized _kGoogleMap here
              markers: Set<Marker>.of(markers),
              onMapCreated: (controller) {
                _googleMapController.complete(controller);
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: controller,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: 'Search Location',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(color: back, width: 2),
                            borderRadius: BorderRadius.circular(15)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: back, width: 2),
                            borderRadius: BorderRadius.circular(15))),
                    onEditingComplete: () async {
                      setState(() {
                        showContain = false;
                      });
                      LatLng latLng =
                          await getCoordinates(controller.text.toString());

                      await _getCurrentLocation().then((value) async {
                        LatLng startlatlng =
                            LatLng(value!.latitude, value!.longitude);
                        LatLng destlatlng = latLng;
                        GoogleMapController googleController =
                            await _googleMapController.future;
                        if (kDebugMode) {
                          print(
                              "kkjfdkgjhsdfkgjhdsfkjghdfskjlghdfkjghfdkjhg$startlatlng");
                        }

                        googleController
                            .animateCamera(CameraUpdate.newCameraPosition(
                                CameraPosition(target: startlatlng, zoom: 14)))
                            .then((value) {
                          setState(() {});
                        });
                        await getTime(startlatlng, destlatlng);
                        await _getPolylines(startlatlng, destlatlng);
                        await _addMarkers(startlatlng, destlatlng);
                      });
                    },
                    onTap: () {
                      setState(() {
                        showContain = true;
                      });
                    },
                  ),
                  Visibility(
                    visible: showContain,
                    child: Container(
                      height: height * 0.2,
                      width: width * 0.9,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          )),
                      child: ListView.builder(
                          itemCount: places.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                                onTap: () {
                                  setState(() {
                                    controller.text =
                                        places[index]['description'].toString();
                                  });
                                },
                                title: Text(
                                    places[index]['description'].toString()));
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          height: height * 0.1,
          width: width,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Time: $time',
                style: const TextStyle(color: back, fontSize: 25),
              ),
              Text(
                'Distance: $distance',
                style: const TextStyle(color: back, fontSize: 25),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
