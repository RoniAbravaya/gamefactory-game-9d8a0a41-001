import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';

class AssetLoader {
  static final AssetLoader _instance = AssetLoader._internal();
  factory AssetLoader() => _instance;
  AssetLoader._internal();

  bool _loaded = false;

  Future<void> loadAll() async {
    if (_loaded) return;

    try {
      await Flame.images.loadAll([
        'player.png',
        'obstacle.png',
        'collectible.png',
        'background.png',
      ]);
      _loaded = true;
    } catch (e) {
      if (kDebugMode) {
        print('[Assets] Failed to load: $e');
      }
    }
  }

  bool get isLoaded => _loaded;
}
