import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/storage_service.dart';
import '../../services/ad_service.dart';
import '../../services/analytics_service.dart';
import '../../services/audio_service.dart';
import '../../config/levels.dart';

class LevelCompleteOverlay extends StatelessWidget {
  final dynamic game;

  const LevelCompleteOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<StorageService>(context, listen: false);
    final adService = Provider.of<AdService>(context, listen: false);
    final analytics = Provider.of<AnalyticsService>(context, listen: false);
    final audio = AudioService();
    
    audio.playSound('success');

    final nextLevel = game.currentLevel + 1;
    final isNextFree = LevelConfigs.isLevelFree(nextLevel);
    final isNextUnlocked = storage.isLevelUnlocked(nextLevel);
    final canProceed = nextLevel <= 10;

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
                const Icon(Icons.celebration, color: Colors.amber, size: 64),
                const SizedBox(height: 16),
                const Text(
                  'LEVEL COMPLETE!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Score: ${game.score}',
                  style: const TextStyle(color: Colors.amber, fontSize: 24),
                ),
                const SizedBox(height: 24),
                if (canProceed) ...[
                  if (isNextFree || isNextUnlocked)
                    ElevatedButton.icon(
                      onPressed: () {
                        audio.playSound('button');
                        game.nextLevel();
                      },
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('NEXT LEVEL'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                    )
                  else
                    Column(
                      children: [
                        const Text(
                          'Watch an ad to unlock',
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () async {
                            analytics.logUnlockPromptShown(nextLevel);
                            analytics.logRewardedAdStarted(nextLevel);
                            
                            await adService.showRewardedAd(
                              onRewarded: () async {
                                await storage.unlockLevel(nextLevel);
                                analytics.logRewardedAdCompleted(nextLevel);
                                analytics.logLevelUnlocked(nextLevel);
                                audio.playSound('success');
                                game.nextLevel();
                              },
                              onFailed: () {
                                analytics.logRewardedAdFailed(nextLevel, 'cancelled');
                              },
                            );
                          },
                          icon: const Icon(Icons.play_circle),
                          label: const Text('WATCH AD'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                ] else
                  const Text(
                    '🎉 Congratulations!\nYou completed all levels!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.amber, fontSize: 18),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
