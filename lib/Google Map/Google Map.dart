import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppGoogleMap extends StatefulWidget {
  final LatLng latLang;

  const AppGoogleMap({super.key, required this.latLang});

  @override
  State<AppGoogleMap> createState() => _AppGoogleMapState();
}

class _AppGoogleMapState extends State<AppGoogleMap> {
  final Completer<GoogleMapController> _googleMapController = Completer();
  List<Marker> markers = [];
  late CameraPosition _kGoogleMap;
  @override
  void initState() {
    super.initState();
    final List<Marker> list = [
      Marker(markerId: const MarkerId('1'), position: widget.latLang),
    ];
    _kGoogleMap = CameraPosition(target: widget.latLang, zoom: 16);

    markers.addAll(list);

    // You can also set _kGoogleMap as the initialCameraPosition here if needed.
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.location_on),
          onPressed: () async {
            GoogleMapController googleController =
                await _googleMapController.future;
            googleController.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(target: widget.latLang, zoom: 14)));
            setState(() {});
          },
        ),
        body: GoogleMap(
          rotateGesturesEnabled: true,
          compassEnabled: true,
          initialCameraPosition:
              _kGoogleMap, // Use the initialized _kGoogleMap here
          markers: Set<Marker>.of(markers),
          onMapCreated: (controller) {
            _googleMapController.complete(controller);
          },
        ),
      ),
    );
  }
}
