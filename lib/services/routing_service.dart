import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../constants/app_constants.dart';

class RoutingService {
  static Future<List<LatLng>?> getRoute(
    LatLng origin,
    LatLng destination,
  ) async {
    final uri = Uri.parse(
      '${AppConstants.osrmBase}'
      '/${origin.longitude},${origin.latitude}'
      ';${destination.longitude},${destination.latitude}'
      '?overview=full&geometries=geojson',
    );

    try {
      final response = await http.get(
        uri,
        headers: {'User-Agent': 'CirioNazareApp/1.0 (Flutter Academic Project)'},
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final routes = data['routes'] as List<dynamic>?;
        if (routes != null && routes.isNotEmpty) {
          final coords =
              routes[0]['geometry']['coordinates'] as List<dynamic>;
          return coords.map((c) {
            final point = c as List<dynamic>;
            return LatLng(
              (point[1] as num).toDouble(),
              (point[0] as num).toDouble(),
            );
          }).toList();
        }
      }
    } catch (_) {
      // Erros de rede, timeout ou parsing são tratados retornando null
    }
    return null;
  }
}
