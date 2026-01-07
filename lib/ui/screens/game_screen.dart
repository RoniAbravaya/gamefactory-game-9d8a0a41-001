import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../game/game.dart';
import '../../services/analytics_service.dart';
import '../../services/audio_service.dart';
import '../overlays/hud_overlay.dart';
import '../overlays/pause_menu.dart';
import '../overlays/level_complete.dart';
import '../overlays/game_over.dart';

class GameScreen extends StatefulWidget {
  final int initialLevel;
  
  const GameScreen({super.key, this.initialLevel = 1});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with WidgetsBindingObserver {
  late Batch20260107153932Puzzle01Game game;
  late AudioService audioService;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    game = Batch20260107153932Puzzle01Game();
    audioService = AudioService();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    game.analytics = Provider.of<AnalyticsService>(context, listen: false);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    audioService.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      game.pauseGame();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(
            game: game,
            loadingBuilder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorBuilder: (context, error) => Center(
              child: Text('Error: $error'),
            ),
            overlayBuilderMap: {
              'GameOverlay': (context, game) => HudOverlay(game: game as Batch20260107153932Puzzle01Game),
              'PauseOverlay': (context, game) => PauseMenu(game: game as Batch20260107153932Puzzle01Game),
              'LevelCompleteOverlay': (context, game) => LevelCompleteOverlay(game: game as Batch20260107153932Puzzle01Game),
              'GameOverOverlay': (context, game) => GameOverOverlay(game: game as Batch20260107153932Puzzle01Game),
            },
            initialActiveOverlays: const ['GameOverlay'],
          ),
        ],
      ),
    );
  }
}
