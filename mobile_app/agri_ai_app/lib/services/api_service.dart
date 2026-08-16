import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://192.168.1.152:8000';

  // Local knowledge base: class name -> description & recommendation
  // (the YOLO11n model only returns class + confidence, not explanatory text)
  static const Map<String, Map<String, String>> _diseaseInfo = {
    'Chlorosis': {
      'description':
          'Yellowing of leaf tissue, often caused by a nutrient deficiency or poor root health.',
      'recommendation':
          'Check soil pH and iron/nitrogen levels. Apply a balanced fertilizer if deficiency is confirmed.',
    },
    'Water Excess': {
      'description':
          'Symptoms of overwatering, leading to waterlogged roots and reduced oxygen uptake.',
      'recommendation':
          'Improve drainage and reduce watering frequency. Avoid standing water around the roots.',
    },
    'Sun Excess': {
      'description':
          'Leaf scorching caused by excessive direct sunlight exposure.',
      'recommendation':
          'Provide partial shade during peak sun hours, especially for young plants.',
    },
    'Harmful Insects': {
      'description':
          'Visible damage caused by pest insects feeding on plant tissue.',
      'recommendation':
          'Inspect the plant for pests and apply an appropriate organic or targeted insecticide.',
    },
    'Water Deficiency': {
      'description':
          'Wilting or dry leaf tissue caused by insufficient water supply.',
      'recommendation':
          'Increase watering frequency and check soil moisture regularly.',
    },
    'Sun Deficiency': {
      'description':
          'Pale or elongated growth due to insufficient light exposure.',
      'recommendation':
          'Relocate the plant to a location with more direct sunlight.',
    },
    'Powdery Mildew': {
      'description':
          'A fungal disease appearing as white powdery spots on leaves, favored by humid conditions.',
      'recommendation':
          'Improve air circulation, avoid overhead watering, and apply a fungicide if severe.',
    },
    'Parasites': {
      'description':
          'Presence of parasitic organisms affecting plant health and leaf integrity.',
      'recommendation':
          'Isolate the affected plant and treat with an appropriate anti-parasitic treatment.',
    },
    'Abnormal Redness': {
      'description':
          'Unusual reddish discoloration of leaves, often linked to stress or nutrient imbalance.',
      'recommendation':
          'Check for phosphorus deficiency or temperature stress and adjust growing conditions.',
    },
    'Bacterial Spot': {
      'description':
          'A bacterial infection causing dark, water-soaked spots on leaves and fruit.',
      'recommendation':
          'Remove affected leaves, avoid overhead irrigation, and apply a copper-based bactericide.',
    },
    'Early Blight': {
      'description':
          'A fungal disease causing concentric dark spots, typically starting on lower leaves.',
      'recommendation':
          'Remove infected foliage, rotate crops, and apply a fungicide preventively.',
    },
    'Healthy': {
      'description':
          'No visible signs of disease detected. The plant appears healthy.',
      'recommendation': 'Continue regular care and monitoring.',
    },
    'Late Blight': {
      'description':
          'A fast-spreading fungal disease causing dark lesions, potentially devastating to crops.',
      'recommendation':
          'Remove and destroy infected plants immediately; apply fungicide to remaining crop.',
    },
    'Leaf Mold': {
      'description':
          'A fungal disease causing yellow patches on the upper leaf surface and mold underneath.',
      'recommendation':
          'Increase ventilation, reduce humidity, and remove affected leaves.',
    },
    'Leaf Miner': {
      'description':
          'Larvae tunneling through leaf tissue, creating visible winding trails.',
      'recommendation':
          'Remove and destroy affected leaves; consider introducing natural predators or insecticide.',
    },
    'Mosaic Virus': {
      'description':
          'A viral infection causing mottled light and dark green patterns on leaves.',
      'recommendation':
          'Remove infected plants to prevent spread; disinfect tools between uses. No cure available.',
    },
    'Septoria': {
      'description':
          'A fungal disease causing small circular spots with dark borders on leaves.',
      'recommendation':
          'Remove infected leaves, avoid wetting foliage, and apply a fungicide if needed.',
    },
    'Spider Mites': {
      'description':
          'Tiny pests causing stippled, discolored leaves, often with fine webbing.',
      'recommendation':
          'Increase humidity, rinse leaves with water, or apply a miticide if infestation is severe.',
    },
    'Yellow Leaf Curl': {
      'description':
          'A viral disease causing upward curling and yellowing of leaves, spread by whiteflies.',
      'recommendation':
          'Control whitefly populations and remove infected plants; no direct cure available.',
    },
    'CBB': {
      'description':
          'Cassava Bacterial Blight, a bacterial disease causing wilting and leaf spots on cassava.',
      'recommendation':
          'Use disease-free planting material and remove infected plants promptly.',
    },
    'CBSD': {
      'description':
          'Cassava Brown Streak Disease, a viral disease causing brown streaking in roots and stems.',
      'recommendation':
          'Use certified virus-free cuttings and control whitefly vectors.',
    },
    'CGM': {
      'description':
          'Cassava Green Mite infestation, causing leaf distortion and reduced yield.',
      'recommendation':
          'Introduce natural predators or apply an appropriate miticide.',
    },
    'CMD': {
      'description':
          'Cassava Mosaic Disease, a viral disease causing mosaic leaf patterns and stunted growth.',
      'recommendation':
          'Use resistant varieties and disease-free planting material.',
    },
    'CASSAVA_HEALTHY': {
      'description':
          'No visible signs of disease detected on the cassava plant.',
      'recommendation': 'Continue regular care and monitoring.',
    },
  };

  static Future<Map<String, dynamic>> analyzeImage(File imageFile) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/detect'));
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );
      var response = await request.send().timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final body = await response.stream.bytesToString();
        final Map<String, dynamic> raw = json.decode(body);

        final List<dynamic> detections = raw['detections'] ?? [];
        final Map<String, dynamic>? envData = raw['environmental_data'];

        if (detections.isEmpty) {
          return {
            'disease': 'No disease detected',
            'confidence': 0.0,
            'description': 'No clear symptoms were detected in this image.',
            'recommendation':
                'Try taking a closer, well-lit photo of the affected leaf area.',
            'temperature': envData?['temperature'],
            'humidity': envData?['humidity'],
          };
        }

        detections.sort(
          (a, b) => (b['confidence'] as num).compareTo(a['confidence'] as num),
        );
        final best = detections.first;

        final String diseaseName = best['class'] ?? 'Unknown';
        final double confidencePercent = (best['confidence'] ?? 0.0) * 100;
        final info =
            _diseaseInfo[diseaseName] ??
            {
              'description':
                  'No additional information available for this class.',
              'recommendation':
                  'Consult a local agronomist for further guidance.',
            };

        return {
          'disease': diseaseName,
          'confidence': confidencePercent,
          'description': info['description'],
          'recommendation': info['recommendation'],
          'temperature': envData?['temperature'],
          'humidity': envData?['humidity'],
        };
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception(
        'Unable to reach the device.\nPlease connect to the same WiFi network as the Jetson Nano.',
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
