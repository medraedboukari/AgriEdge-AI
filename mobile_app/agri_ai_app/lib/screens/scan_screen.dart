import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../services/api_service.dart';
import 'result_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  File? _image;
  bool _isAnalyzing = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? img = await _picker.pickImage(
      source: source,
      imageQuality: 90,
      maxWidth: 640,
      maxHeight: 640,
    );
    if (img != null) setState(() => _image = File(img.path));
  }

  Future<void> _analyze() async {
    if (_image == null) return;
    setState(() => _isAnalyzing = true);
    try {
      final result = await ApiService.analyzeImage(_image!);
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(result: result, image: _image!),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.wifi_off_rounded, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(child: Text(e.toString())),
              ],
            ),
            backgroundColor: Colors.red[700],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isAnalyzing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAF7),
      appBar: AppBar(
        title: const Text(
          'Scan Plant',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1B8A4C),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _pickImage(ImageSource.camera),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: _image != null
                          ? const Color(0xFF1B8A4C)
                          : const Color(0xFFE0E0E0),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: Image.file(_image!, fit: BoxFit.cover),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF1B8A4C,
                                ).withOpacity(0.08),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add_a_photo_rounded,
                                size: 52,
                                color: Color(0xFF1B8A4C),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Tap to take a photo',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'or choose from gallery below',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF999999),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _SourceButton(
                    icon: Icons.camera_alt_rounded,
                    label: 'Camera',
                    onTap: () => _pickImage(ImageSource.camera),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SourceButton(
                    icon: Icons.photo_library_rounded,
                    label: 'Gallery',
                    onTap: () => _pickImage(ImageSource.gallery),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                onPressed: _image != null && !_isAnalyzing ? _analyze : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B8A4C),
                  disabledBackgroundColor: const Color(0xFFCCCCCC),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: _image != null ? 4 : 0,
                  shadowColor: const Color(0xFF1B8A4C).withOpacity(0.4),
                ),
                child: _isAnalyzing
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SpinKitThreeBounce(color: Colors.white, size: 20),
                          SizedBox(width: 12),
                          Text(
                            'Analyzing...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_rounded, size: 22),
                          SizedBox(width: 8),
                          Text(
                            'Diagnose Now',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SourceButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE0E0E0)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF1B8A4C), size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
