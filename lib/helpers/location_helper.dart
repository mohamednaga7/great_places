import 'dart:convert';

import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;

class LocationHelper {
  static String generateLocationPreviewImage(
      {required double latitude, required double longitude}) {
    final GOOGLE_API_KEY = FlutterConfig.get('GOOGLE_API_KEY');
    return "https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=17&size=600x300&maptype=roadmap&markers=color:red%7Clabel:S%7C$latitude,$longitude&key=$GOOGLE_API_KEY";
  }

  static Future<String> getPlaceAddress(double lat, double lng) async {
    final GOOGLE_API_KEY = FlutterConfig.get('GOOGLE_API_KEY');
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=40.714224,-73.961452&key=$GOOGLE_API_KEY');
    final response = await http.get(url);
    try {
      final responseBody = json.decode(response.body);
      if (responseBody != null) {
        return responseBody['results'][0]['formatted_address'];
      }
      throw Exception('Error retrieving the address');
    } catch (error) {
      rethrow;
    }
  }
}
