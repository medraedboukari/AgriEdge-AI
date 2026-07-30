import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://192.168.1.1:8000';

  static Future<Map<String, dynamic>> analyzeImage(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/predict'),
      );
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );
      var response = await request.send().timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        final body = await response.stream.bytesToString();
        return json.decode(body);
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception(
        'Unable to reach the device.\nPlease connect to PlantCare WiFi.',
      );
    } on Exception catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<bool> checkConnection() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/health'))
          .timeout(const Duration(seconds: 3));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
