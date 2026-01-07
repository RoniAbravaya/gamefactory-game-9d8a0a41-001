import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

/// The main menu scene for the puzzle game.
class MenuScene extends Component {
  /// The title of the game.
  final String gameTitle;

  /// The tagline of the game.
  final String gameTagline;

  /// The callback to start the game.
  final VoidCallback onPlayPressed;

  /// The callback to navigate to the level select screen.
  final VoidCallback onLevelSelectPressed;

  /// The callback to navigate to the settings screen.
  final VoidCallback onSettingsPressed;

  /// Creates a new instance of the [MenuScene] component.
  MenuScene({
    required this.gameTitle,
    required this.gameTagline,
    required this.onPlayPressed,
    required this.onLevelSelectPressed,
    required this.onSettingsPressed,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Add title display
    add(TextComponent(
      text: gameTitle,
      position: Vector2(size.x / 2, 100),
      anchor: Anchor.topCenter,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ));

    // Add tagline
    add(TextComponent(
      text: gameTagline,
      position: Vector2(size.x / 2, 160),
      anchor: Anchor.topCenter,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 24,
          color: Colors.white,
        ),
      ),
    ));

    // Add play button
    add(ButtonComponent(
      position: Vector2(size.x / 2, 240),
      anchor: Anchor.topCenter,
      size: Vector2(200, 60),
      child: TextComponent(
        text: 'Play',
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
      onPressed: onPlayPressed,
    ));

    // Add level select button
    add(ButtonComponent(
      position: Vector2(size.x / 2, 320),
      anchor: Anchor.topCenter,
      size: Vector2(200, 60),
      child: TextComponent(
        text: 'Level Select',
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
      onPressed: onLevelSelectPressed,
    ));

    // Add settings button
    add(ButtonComponent(
      position: Vector2(size.x / 2, 400),
      anchor: Anchor.topCenter,
      size: Vector2(200, 60),
      child: TextComponent(
        text: 'Settings',
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
      onPressed: onSettingsPressed,
    ));

    // Add background animation
    add(BackgroundAnimation());
  }
}

/// A simple background animation for the menu scene.
class BackgroundAnimation extends Component with HasGameRef {
  @override
  void update(double dt) {
    super.update(dt);
    position.x += 0.5;
    position.y += 0.3;
    if (position.x > gameRef.size.x) {
      position.x = -100;
    }
    if (position.y > gameRef.size.y) {
      position.y = -100;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(
      Rect.fromLTWH(position.x, position.y, 100, 100),
      Paint()..color = const Color(0xFFFFFFFF),
    );
  }
}