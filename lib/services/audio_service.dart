import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  bool _soundEnabled = true;
  bool _musicEnabled = true;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      await FlameAudio.audioCache.loadAll([
        'button.wav',
        'collect.wav',
        'hit.wav',
        'success.wav',
        'fail.wav',
      ]);
      _initialized = true;
    } catch (e) {
      if (kDebugMode) {
        print('[Audio] Failed to initialize: $e');
      }
    }
  }

  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
  }

  void setMusicEnabled(bool enabled) {
    _musicEnabled = enabled;
    if (!enabled) {
      FlameAudio.bgm.stop();
    }
  }

  void playSound(String name) {
    if (!_soundEnabled || !_initialized) return;
    
    try {
      FlameAudio.play('$name.wav');
    } catch (e) {
      if (kDebugMode) {
        print('[Audio] Failed to play sound: $e');
      }
    }
  }

  void playMusic(String name) {
    if (!_musicEnabled || !_initialized) return;
    
    try {
      FlameAudio.bgm.play('$name.mp3');
    } catch (e) {
      if (kDebugMode) {
        print('[Audio] Failed to play music: $e');
      }
    }
  }

  void stopMusic() {
    FlameAudio.bgm.stop();
  }

  void dispose() {
    FlameAudio.bgm.stop();
  }
}
