import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';

/// Ad service for managing rewarded ads
/// 
/// Handles ad loading, showing, and reward callbacks.
/// Includes error handling for cases where ads are not available.
class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();
  
  RewardedAd? _rewardedAd;
  bool _initialized = false;
  
  // Test ad unit IDs - replace with real ones in production
  static const String _rewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';
  
  Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      await MobileAds.instance.initialize();
      _initialized = true;
      await _loadRewardedAd();
      
      if (kDebugMode) {
        print('[AdService] Initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('[AdService] Failed to initialize: $e');
      }
      _initialized = false;
    }
  }
  
  Future<void> _loadRewardedAd() async {
    if (!_initialized) return;
    
    try {
      await RewardedAd.load(
        adUnitId: _rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _rewardedAd = ad;
            if (kDebugMode) {
              print('[AdService] Rewarded ad loaded');
            }
          },
          onAdFailedToLoad: (error) {
            _rewardedAd = null;
            if (kDebugMode) {
              print('[AdService] Failed to load rewarded ad: ${error.message}');
            }
          },
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('[AdService] Error loading ad: $e');
      }
    }
  }
  
  bool get isAdReady => _rewardedAd != null;
  
  Future<bool> showRewardedAd({
    required Function onRewarded,
    Function? onFailed,
  }) async {
    if (_rewardedAd == null) {
      if (kDebugMode) {
        print('[AdService] No ad available, simulating reward for debug');
        // In debug mode, simulate reward for testing
        onRewarded();
        return true;
      }
      onFailed?.call();
      return false;
    }
    
    try {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _rewardedAd = null;
          _loadRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _rewardedAd = null;
          _loadRewardedAd();
          onFailed?.call();
        },
      );
      
      await _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          onRewarded();
        },
      );
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('[AdService] Error showing ad: $e');
      }
      onFailed?.call();
      return false;
    }
  }
}
