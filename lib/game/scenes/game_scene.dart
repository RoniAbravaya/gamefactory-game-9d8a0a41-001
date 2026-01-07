import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

/// The main game scene that handles level loading, game logic, and UI elements.
class GameScene extends Component with HasGameRef {
  /// The current level being played.
  int currentLevel = 1;

  /// The player component.
  late Player player;

  /// The score display component.
  late ScoreDisplay scoreDisplay;

  /// The game timer component.
  late GameTimer gameTimer;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _loadLevel(currentLevel);
  }

  /// Loads the specified level and sets up the game components.
  Future<void> _loadLevel(int level) async {
    try {
      // Load level data (board size, timer duration, etc.)
      final levelData = await loadLevelData(level);

      // Spawn the player
      player = Player(levelData.playerStartPosition);
      add(player);

      // Spawn obstacles and collectibles
      for (final obstacle in levelData.obstacles) {
        add(Obstacle(obstacle.position, obstacle.size));
      }
      for (final collectible in levelData.collectibles) {
        add(Collectible(collectible.position, collectible.value));
      }

      // Set up the score display
      scoreDisplay = ScoreDisplay(levelData.targetScore);
      add(scoreDisplay);

      // Set up the game timer
      gameTimer = GameTimer(levelData.timerDuration);
      add(gameTimer);
    } catch (e) {
      // Handle errors gracefully
      print('Error loading level $level: $e');
      // Potentially show an error message to the player
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update game logic
    player.update(dt);
    gameTimer.update(dt);

    // Check for win/lose conditions
    if (gameTimer.isTimeUp) {
      // Player lost, show game over screen
      gameOver();
    } else if (scoreDisplay.targetScore <= scoreDisplay.currentScore) {
      // Player won, show level complete screen
      levelComplete();
    }
  }

  /// Handles the game over scenario.
  void gameOver() {
    // Implement game over logic, such as showing a retry prompt or ad
  }

  /// Handles the level complete scenario.
  void levelComplete() {
    // Implement level complete logic, such as showing a level complete screen and unlocking the next level
    currentLevel++;
    _loadLevel(currentLevel);
  }

  /// Pauses the game.
  void pauseGame() {
    gameTimer.pause();
  }

  /// Resumes the game.
  void resumeGame() {
    gameTimer.resume();
  }
}

/// The player component.
class Player extends SpriteComponent {
  /// Creates a new player component.
  Player(Vector2 position) : super(position: position, size: Vector2.all(50));

  @override
  void update(double dt) {
    super.update(dt);
    // Implement player movement and interaction logic
  }
}

/// The score display component.
class ScoreDisplay extends TextComponent {
  /// The target score for the level.
  final int targetScore;

  /// The current score.
  int currentScore = 0;

  /// Creates a new score display component.
  ScoreDisplay(this.targetScore)
      : super(
          text: 'Score: $currentScore/$targetScore',
          position: Vector2(20, 20),
          textRenderer: TextPaint(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        );

  @override
  void update(double dt) {
    super.update(dt);
    // Update the score display text
    text = 'Score: $currentScore/$targetScore';
  }

  /// Increases the current score by the specified amount.
  void increaseScore(int amount) {
    currentScore += amount;
  }
}

/// The game timer component.
class GameTimer extends TextComponent {
  /// The duration of the timer in seconds.
  final double timerDuration;

  /// The current time remaining.
  double timeRemaining;

  /// Indicates whether the timer has run out.
  bool get isTimeUp => timeRemaining <= 0;

  /// Creates a new game timer component.
  GameTimer(this.timerDuration)
      : timeRemaining = timerDuration,
        super(
          text: '$timeRemaining',
          position: Vector2(gameRef.size.x - 100, 20),
          textRenderer: TextPaint(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        );

  @override
  void update(double dt) {
    super.update(dt);
    // Update the timer
    timeRemaining = max(timeRemaining - dt, 0);
    text = '${timeRemaining.toStringAsFixed(1)}';
  }

  /// Pauses the timer.
  void pause() {
    // Implement pause logic
  }

  /// Resumes the timer.
  void resume() {
    // Implement resume logic
  }
}

/// The obstacle component.
class Obstacle extends SpriteComponent {
  /// Creates a new obstacle component.
  Obstacle(Vector2 position, Vector2 size)
      : super(position: position, size: size);
}

/// The collectible component.
class Collectible extends SpriteComponent {
  /// The value of the collectible.
  final int value;

  /// Creates a new collectible component.
  Collectible(Vector2 position, this.value)
      : super(position: position, size: Vector2.all(30));

  @override
  void update(double dt) {
    super.update(dt);
    // Implement collectible interaction logic
  }
}