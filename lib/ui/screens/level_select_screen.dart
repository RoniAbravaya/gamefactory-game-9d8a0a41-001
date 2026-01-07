import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/storage_service.dart';
import '../../services/audio_service.dart';
import '../../config/levels.dart';
import 'game_screen.dart';

class LevelSelectScreen extends StatelessWidget {
  const LevelSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<StorageService>(context, listen: false);
    final unlockedLevels = storage.getUnlockedLevels();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Level'),
        backgroundColor: const Color(0xFF1A1A2E),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          ),
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemCount: LevelConfigs.totalLevels,
          itemBuilder: (context, index) {
            final level = LevelConfigs.levels[index];
            final isUnlocked = unlockedLevels.contains(level.levelNumber);
            final highScore = storage.getHighScores()[level.levelNumber] ?? 0;

            return _LevelTile(
              level: level,
              isUnlocked: isUnlocked,
              highScore: highScore,
              onTap: isUnlocked
                  ? () {
                      AudioService().playSound('button');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GameScreen(initialLevel: level.levelNumber),
                        ),
                      );
                    }
                  : null,
            );
          },
        ),
      ),
    );
  }
}

class _LevelTile extends StatelessWidget {
  final LevelConfig level;
  final bool isUnlocked;
  final int highScore;
  final VoidCallback? onTap;

  const _LevelTile({
    required this.level,
    required this.isUnlocked,
    required this.highScore,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isUnlocked ? Colors.deepPurple : Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
          border: level.isFree
              ? Border.all(color: Colors.amber, width: 2)
              : null,
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isUnlocked) ...[
              Text(
                '${level.levelNumber}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (highScore > 0)
                Text(
                  '⭐ $highScore',
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 12,
                  ),
                ),
            ] else
              const Icon(Icons.lock, color: Colors.white54, size: 32),
          ],
        ),
      ),
    );
  }
}
