import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/input.dart';

/// The player character in the puzzle game.
class Player extends SpriteAnimationComponent
    with CollisionCallbacks, KeyboardHandler {
  /// The player's current score.
  int score = 0;

  /// The player's remaining lives.
  int lives = 3;

  /// The player's current animation state.
  PlayerState state = PlayerState.idle;

  /// Initializes a new instance of the [Player] class.
  Player({
    required Vector2 position,
    required SpriteAnimation idleAnimation,
    required SpriteAnimation movingAnimation,
    required SpriteAnimation jumpingAnimation,
  }) : super(
          position: position,
          size: Vector2.all(64),
          animation: idleAnimation,
        ) {
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.moving: movingAnimation,
      PlayerState.jumping: jumpingAnimation,
    };
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Update player state and animation based on input
    switch (state) {
      case PlayerState.idle:
        // Handle idle state
        break;
      case PlayerState.moving:
        // Handle moving state
        break;
      case PlayerState.jumping:
        // Handle jumping state
        break;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    // Handle collisions with other game objects
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // Handle player input and update state accordingly
    if (event is RawKeyDownEvent) {
      if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
        state = PlayerState.moving;
        // Move player left
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
        state = PlayerState.moving;
        // Move player right
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
        state = PlayerState.jumping;
        // Make player jump
      }
    } else if (event is RawKeyUpEvent) {
      if (!keysPressed.contains(LogicalKeyboardKey.arrowLeft) &&
          !keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
        state = PlayerState.idle;
        // Stop player movement
      }
    }
    return true;
  }

  /// Increases the player's score by the specified amount.
  void increaseScore(int amount) {
    score += amount;
  }

  /// Decreases the player's remaining lives by 1.
  void loseLife() {
    lives--;
  }
}

/// Represents the different states the player character can be in.
enum PlayerState {
  idle,
  moving,
  jumping,
}