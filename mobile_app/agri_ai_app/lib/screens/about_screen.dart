import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAF7),
      appBar: AppBar(
        title: const Text(
          'About',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1B8A4C),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1B8A4C), Color(0xFF0D5C32)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1B8A4C).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.eco_rounded,
                size: 52,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'PlantCare AI',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const Text(
              'Version 1.0.0',
              style: TextStyle(color: Color(0xFF999999), fontSize: 13),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Diagnose. Treat. Grow.',
                style: TextStyle(
                  color: Color(0xFF1B8A4C),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Text(
                'PlantCare AI helps farmers and gardeners instantly detect plant diseases using advanced AI technology — no internet required, results in seconds.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.7,
                  color: Color(0xFF555555),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _InfoTile(
              icon: Icons.eco_rounded,
              title: 'Diseases Supported',
              value: '24 plant conditions',
            ),
            _InfoTile(
              icon: Icons.bolt_rounded,
              title: 'Response Time',
              value: 'Under 1 second',
            ),
            _InfoTile(
              icon: Icons.wifi_off_rounded,
              title: 'Connectivity',
              value: 'Works without internet',
            ),
            _InfoTile(
              icon: Icons.photo_library_rounded,
              title: 'Input',
              value: 'Camera or Gallery',
            ),
            const SizedBox(height: 28),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              '© 2026 PlantCare AI',
              style: TextStyle(fontSize: 12, color: Colors.grey[400]),
            ),
            const SizedBox(height: 4),
            Text(
              'Built with ❤️ for farmers worldwide',
              style: TextStyle(fontSize: 12, color: Colors.grey[400]),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF1B8A4C), size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF999999),
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
