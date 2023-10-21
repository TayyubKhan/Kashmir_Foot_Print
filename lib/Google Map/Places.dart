import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

Future<dynamic> getSuggestions(String text) async {
  String input = text;
  var uuid = const Uuid().v4();
  List<dynamic> places = [];
  String sessionToken = '12345';

  String kPlacesApiKey = 'AIzaSyBrDLtzgJD3h1MibAYXbuJPBOIQrq3rfKY';
  String baseURL =
      "https://maps.googleapis.com/maps/api/place/autocomplete/json";
  String request =
      '$baseURL?input=$input&key=$kPlacesApiKey&sessiontoken=$sessionToken';
  var response = await http.get(Uri.parse(request));
  if (kDebugMode) {
    print(response.body.toString());
  }
  if (response.statusCode == 200) {
    places = jsonDecode(response.body.toString())['predictions'];
  } else {
    throw Exception('failed');
  }
  return response;
}

Future<LatLng> getCoordinates(String placeName) async {
  List<Location> locations = await locationFromAddress(placeName);
  print(LatLng(locations[0].latitude, locations[0].longitude));
  if (locations.isNotEmpty) {
    return LatLng(locations[0].latitude, locations[0].longitude);
  } else {
    throw Exception("Location not found");
  }
}
