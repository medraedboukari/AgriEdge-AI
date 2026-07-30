import 'package:flutter/material.dart';
import 'scan_screen.dart';
import 'history_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAF7),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: const Color(0xFF1B8A4C),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1B8A4C), Color(0xFF0D5C32)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.eco_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'PlantCare AI',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(
                                Icons.info_outline_rounded,
                                color: Colors.white70,
                              ),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AboutScreen(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Good day, Farmer! 🌿',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Is your plant feeling sick today?',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main scan button
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ScanScreen()),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1B8A4C), Color(0xFF0D5C32)],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1B8A4C).withOpacity(0.35),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.document_scanner_rounded,
                              color: Colors.white,
                              size: 34,
                            ),
                          ),
                          const SizedBox(width: 18),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Scan a Plant',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Take a photo to get instant diagnosis',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white70,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Features',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 14),

                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 1.1,
                    children: [
                      _FeatureTile(
                        icon: Icons.bolt_rounded,
                        title: 'Instant Results',
                        subtitle: 'Diagnosis in seconds',
                        color: const Color(0xFF1B8A4C),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ScanScreen()),
                        ),
                      ),
                      _FeatureTile(
                        icon: Icons.history_rounded,
                        title: 'History',
                        subtitle: 'Past diagnoses',
                        color: const Color(0xFF0277BD),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HistoryScreen(),
                          ),
                        ),
                      ),
                      _FeatureTile(
                        icon: Icons.wifi_off_rounded,
                        title: 'Offline Ready',
                        subtitle: 'No internet needed',
                        color: const Color(0xFF6A1B9A),
                        onTap: null,
                      ),
                      _FeatureTile(
                        icon: Icons.local_florist_rounded,
                        title: '24 Diseases',
                        subtitle: 'Multi-crop detection',
                        color: const Color(0xFFE65100),
                        onTap: null,
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Quick Tips',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 14),

                  _TipCard(
                    icon: Icons.wb_sunny_rounded,
                    tip:
                        'Take photos in good lighting for more accurate results.',
                    color: const Color(0xFFFFF8E1),
                    iconColor: const Color(0xFFF9A825),
                  ),
                  const SizedBox(height: 10),
                  _TipCard(
                    icon: Icons.center_focus_strong_rounded,
                    tip: 'Focus on the affected leaf and avoid blurry images.',
                    color: const Color(0xFFE8F5E9),
                    iconColor: const Color(0xFF2E7D32),
                  ),
                  const SizedBox(height: 10),
                  _TipCard(
                    icon: Icons.wifi_rounded,
                    tip: 'Connect to PlantCare device WiFi before scanning.',
                    color: const Color(0xFFE3F2FD),
                    iconColor: const Color(0xFF1565C0),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: Color(0xFF999999)),
            ),
          ],
        ),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final IconData icon;
  final String tip;
  final Color color;
  final Color iconColor;

  const _TipCard({
    required this.icon,
    required this.tip,
    required this.color,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(tip, style: const TextStyle(fontSize: 13, height: 1.4)),
          ),
        ],
      ),
    );
  }
}
