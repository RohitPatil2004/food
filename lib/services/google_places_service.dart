import 'package:http/http.dart' as http;
import 'dart:convert';

class GooglePlacesService {
  static const String _apiKey = 'AIzaSyDU_jztpM8Voo-akYziQyoNQoTeJfcWCm4';
  static const String _detailsEndpoint = 'https://maps.googleapis.com/maps/api/place/details/json';
  static const String _photosEndpoint = 'https://maps.googleapis.com/maps/api/place/photo';

  static Future<Map<String, dynamic>> getPlaceDetails(String placeId) async {
    final url = Uri.parse(
      '$_detailsEndpoint?place_id=$placeId&fields=name,formatted_address,formatted_phone_number,website,rating,photos&key=$_apiKey'
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['result'];
      }
      return {};
    } catch (e) {
      return {};
    }
  }

  static String getPhotoUrl(String photoReference, {int maxWidth = 400}) {
    return '$_photosEndpoint?maxwidth=$maxWidth&photoreference=$photoReference&key=$_apiKey';
  }
}
