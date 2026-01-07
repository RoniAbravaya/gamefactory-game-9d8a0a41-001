import 'package:flutter/material.dart';
import '../../services/audio_service.dart';
import 'game_screen.dart';
import 'settings_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
    
    AudioService().playMusic('menu');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Text(
                  'Batch-20260107-153932-puzzle-01',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Swap tiles to beat the clock and score big!',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                _MenuButton(
                  text: 'PLAY',
                  onPressed: () {
                    AudioService().playSound('button');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GameScreen()),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _MenuButton(
                  text: 'SETTINGS',
                  outlined: true,
                  onPressed: () {
                    AudioService().playSound('button');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    );
                  },
                ),
                const Spacer(),
                const Text(
                  'Made with GameFactory',
                  style: TextStyle(color: Colors.white38, fontSize: 12),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool outlined;

  const _MenuButton({
    required this.text,
    required this.onPressed,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    if (outlined) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white54),
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
        ),
        child: Text(text, style: const TextStyle(fontSize: 18)),
      );
    }
    
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 16),
        elevation: 8,
      ),
      child: Text(text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }
}
