import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryService {
  static const String _key = 'analysis_history';

  static Future<void> saveResult({
    required String disease,
    required double confidence,
    required String description,
    required String recommendation,
    required String imagePath,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();
    history.insert(0, {
      'disease': disease,
      'confidence': confidence,
      'description': description,
      'recommendation': recommendation,
      'imagePath': imagePath,
      'date': DateTime.now().toIso8601String(),
    });
    if (history.length > 20) history.removeLast();
    await prefs.setString(_key, json.encode(history));
  }

  static Future<List<Map<String, dynamic>>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final List<dynamic> decoded = json.decode(raw);
    return decoded.cast<Map<String, dynamic>>();
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
