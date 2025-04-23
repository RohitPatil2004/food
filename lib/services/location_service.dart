import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationService {
  static const String _apiKey = '0b6851160b6d40788b34723c334e4184';
  static const String _placesEndpoint = 'https://api.geoapify.com/v2/places';

  static Future<bool> checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  static Future<Position?> getCurrentLocation() async {
    bool hasPermission = await checkPermission();
    if (!hasPermission) return null;

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  static Future<List<Map<String, dynamic>>> getNearbyRestaurants(Position position) async {
    final url = Uri.parse(
      '$_placesEndpoint?categories=catering.restaurant&filter=circle:${position.longitude},${position.latitude},5000&bias=proximity:${position.longitude},${position.latitude}&limit=20&apiKey=$_apiKey'
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['features']);
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
