import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/history_service.dart';
import 'result_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> _history = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final h = await HistoryService.getHistory();
    setState(() => _history = h);
  }

  Future<void> _clear() async {
    await HistoryService.clearHistory();
    setState(() => _history = []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAF7),
      appBar: AppBar(
        title: const Text(
          'History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1B8A4C),
        foregroundColor: Colors.white,
        actions: [
          if (_history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded),
              onPressed: () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Clear History'),
                    content: const Text('Delete all past diagnoses?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text(
                          'Clear',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
                if (ok == true) _clear();
              },
            ),
        ],
      ),
      body: _history.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history_rounded,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No diagnosis yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start by scanning a plant!',
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _history.length,
              itemBuilder: (_, i) {
                final item = _history[i];
                final date = DateTime.parse(item['date']);
                final formatted = DateFormat(
                  'MMM dd, yyyy — HH:mm',
                ).format(date);
                final confidence = (item['confidence'] as num).toDouble();
                final color = confidence >= 80
                    ? const Color(0xFF2E7D32)
                    : confidence >= 60
                    ? const Color(0xFFF57F17)
                    : const Color(0xFFC62828);

                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ResultScreen(
                        result: item,
                        image: File(item['imagePath']),
                      ),
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: File(item['imagePath']).existsSync()
                              ? Image.file(
                                  File(item['imagePath']),
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 64,
                                  height: 64,
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.image,
                                    color: Colors.grey,
                                  ),
                                ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['disease'] ?? 'Unknown',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${confidence.toStringAsFixed(0)}% confidence',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: color,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formatted,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF999999),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
