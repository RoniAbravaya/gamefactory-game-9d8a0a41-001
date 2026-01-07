import 'package:flutter/material.dart';
import '../../services/audio_service.dart';

class PauseMenu extends StatelessWidget {
  final dynamic game;

  const PauseMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Card(
          color: const Color(0xFF1A1A2E),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'PAUSED',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {
                    AudioService().playSound('button');
                    game.resumeGame();
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('RESUME'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    AudioService().playSound('button');
                    game.restartLevel();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('RESTART'),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () {
                    AudioService().playSound('button');
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.home),
                  label: const Text('MAIN MENU'),
                  style: TextButton.styleFrom(foregroundColor: Colors.white54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
