import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Analytics service for tracking game events
/// 
/// Implements the GameFactory standard event schema.
/// Handles cases where Firebase is not configured.
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  
  factory AnalyticsService({bool firebaseEnabled = false}) {
    _instance._firebaseEnabled = firebaseEnabled;
    return _instance;
  }
  
  AnalyticsService._internal();
  
  FirebaseAnalytics? _analytics;
  bool _initialized = false;
  bool _firebaseEnabled = false;
  
  Future<void> initialize() async {
    if (_initialized) return;
    
    if (_firebaseEnabled) {
      try {
        _analytics = FirebaseAnalytics.instance;
      } catch (e) {
        if (kDebugMode) {
          print('[Analytics] Firebase Analytics not available: $e');
        }
        _firebaseEnabled = false;
      }
    }
    
    _initialized = true;
    
    if (kDebugMode) {
      print('[Analytics] Initialized (Firebase: $_firebaseEnabled)');
    }
  }
  
  Future<void> logEvent(String name, Map<String, dynamic>? params) async {
    if (!_initialized) return;
    
    // Always log to debug console
    if (kDebugMode) {
      print('[Analytics] $name: $params');
    }
    
    // Only log to Firebase if enabled
    if (_firebaseEnabled && _analytics != null) {
      try {
        await _analytics!.logEvent(
          name: name, 
          parameters: params?.map((k, v) => MapEntry(k, v?.toString())),
        );
      } catch (e) {
        if (kDebugMode) {
          print('[Analytics] Failed to log event: $e');
        }
      }
    }
  }
  
  // Standard GameFactory events
  
  Future<void> logGameStart() async {
    await logEvent('game_start', {'timestamp': DateTime.now().toIso8601String()});
  }
  
  Future<void> logLevelStart(int level, {int attemptNumber = 1}) async {
    await logEvent('level_start', {'level': level, 'attempt_number': attemptNumber});
  }
  
  Future<void> logLevelComplete(int level, int score, int timeSeconds) async {
    await logEvent('level_complete', {'level': level, 'score': score, 'time_seconds': timeSeconds});
  }
  
  Future<void> logLevelFail(int level, int score, String reason, int timeSeconds) async {
    await logEvent('level_fail', {'level': level, 'score': score, 'fail_reason': reason, 'time_seconds': timeSeconds});
  }
  
  Future<void> logUnlockPromptShown(int level) async {
    await logEvent('unlock_prompt_shown', {'level': level});
  }
  
  Future<void> logRewardedAdStarted(int level) async {
    await logEvent('rewarded_ad_started', {'level': level});
  }
  
  Future<void> logRewardedAdCompleted(int level) async {
    await logEvent('rewarded_ad_completed', {'level': level});
  }
  
  Future<void> logRewardedAdFailed(int level, String reason) async {
    await logEvent('rewarded_ad_failed', {'level': level, 'reason': reason});
  }
  
  Future<void> logLevelUnlocked(int level) async {
    await logEvent('level_unlocked', {'level': level});
  }
}
