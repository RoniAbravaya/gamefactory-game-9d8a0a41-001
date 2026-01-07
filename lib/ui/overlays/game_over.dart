import 'package:flutter/material.dart';
import '../../services/audio_service.dart';

class GameOverOverlay extends StatelessWidget {
  final dynamic game;

  const GameOverOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    AudioService().playSound('fail');

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
                const Icon(Icons.sentiment_dissatisfied, color: Colors.red, size: 64),
                const SizedBox(height: 16),
                const Text(
                  'GAME OVER',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Score: ${game.score}',
                  style: const TextStyle(color: Colors.white70, fontSize: 20),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    AudioService().playSound('button');
                    game.restartLevel();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('TRY AGAIN'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Main Menu', style: TextStyle(color: Colors.white54)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
