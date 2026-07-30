import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _ctrl = PageController();
  int _page = 0;

  final List<Map<String, dynamic>> _slides = [
    {
      'icon': Icons.search_rounded,
      'title': 'Detect Any Disease',
      'subtitle':
          'Point your camera at any plant leaf and instantly identify diseases across 24 conditions.',
      'gradient': [const Color(0xFF1B8A4C), const Color(0xFF0D5C32)],
    },
    {
      'icon': Icons.bolt_rounded,
      'title': 'Instant Diagnosis',
      'subtitle':
          'Get results in under a second — no internet connection needed, works anywhere in the field.',
      'gradient': [const Color(0xFF0277BD), const Color(0xFF01579B)],
    },
    {
      'icon': Icons.local_florist_rounded,
      'title': 'Save Your Crops',
      'subtitle':
          'Receive clear treatment recommendations to protect your harvest and maximize yield.',
      'gradient': [const Color(0xFF6A1B9A), const Color(0xFF4A148C)],
    },
  ];

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: _ctrl,
            onPageChanged: (i) => setState(() => _page = i),
            itemCount: _slides.length,
            itemBuilder: (_, i) {
              final s = _slides[i];
              return Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: s['gradient'] as List<Color>,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (s['gradient'] as List<Color>)[0]
                                .withOpacity(0.35),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        s['icon'] as IconData,
                        size: 75,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 48),
                    Text(
                      s['title'] as String,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48),
                      child: Text(
                        s['subtitle'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.7,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 130,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _page == i ? 28 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _page == i
                        ? const Color(0xFF1B8A4C)
                        : const Color(0xFFDDDDDD),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _finish,
                  child: const Text(
                    'Skip',
                    style: TextStyle(color: Color(0xFF999999), fontSize: 15),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1B8A4C), Color(0xFF0D5C32)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1B8A4C).withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_page < _slides.length - 1) {
                        _ctrl.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _finish();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 36,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      _page < _slides.length - 1 ? 'Next →' : 'Get Started',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
