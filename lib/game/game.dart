import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import 'game_config.dart';
import 'analytics_service.dart';
import 'game_controller.dart';

/// The main FlameGame subclass for the Batch-20260107-153932-puzzle-01 game.
class Batch20260107153932Puzzle01Game extends FlameGame with TapDetector {
  /// The current game state.
  GameState _gameState = GameState.playing;

  /// The current level being played.
  int _currentLevel = 1;

  /// The player's score.
  int _score = 0;

  /// The player's remaining lives.
  int _lives = 3;

  /// The game configuration.
  late final GameConfig _gameConfig;

  /// The game controller.
  late final GameController _gameController;

  /// The analytics service.
  late final AnalyticsService _analyticsService;

  /// Initializes the game.
  Batch20260107153932Puzzle01Game({
    required GameConfig gameConfig,
    required GameController gameController,
    required AnalyticsService analyticsService,
  }) {
    _gameConfig = gameConfig;
    _gameController = gameController;
    _analyticsService = analyticsService;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Set up the camera and world
    camera.viewport = FixedResolutionViewport(
      Vector2(_gameConfig.boardWidth, _gameConfig.boardHeight),
    );
    camera.followComponent(_gameController);

    // Load the current level
    await _loadLevel(_currentLevel);

    // Log the game start event
    _analyticsService.logGameStart();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update the game state
    switch (_gameState) {
      case GameState.playing:
        // Update the game logic
        _gameController.update(dt);

        // Check for level completion
        if (_gameController.isLevelComplete()) {
          _gameState = GameState.levelComplete;
          _analyticsService.logLevelComplete();
        }

        // Check for game over
        if (_lives <= 0) {
          _gameState = GameState.gameOver;
          _analyticsService.logLevelFail();
        }
        break;
      case GameState.paused:
        // Pause the game logic
        break;
      case GameState.gameOver:
        // Handle game over logic
        break;
      case GameState.levelComplete:
        // Handle level complete logic
        break;
    }
  }

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);

    // Handle user input
    _gameController.onTapDown(info);
  }

  /// Loads the specified level.
  Future<void> _loadLevel(int level) async {
    // Load the level configuration
    final levelConfig = _gameConfig.getLevelConfig(level);

    // Create the game components
    _gameController.loadLevel(levelConfig);

    // Log the level start event
    _analyticsService.logLevelStart(level);
  }

  /// Increments the player's score.
  void _incrementScore(int points) {
    _score += points;
    _gameController.updateScore(_score);
  }

  /// Decrements the player's lives.
  void _decrementLives() {
    _lives--;
    _gameController.updateLives(_lives);
  }
}

/// The possible game states.
enum GameState {
  playing,
  paused,
  gameOver,
  levelComplete,
}