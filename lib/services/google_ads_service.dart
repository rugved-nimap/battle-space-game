import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class GoogleAdsService {
  GoogleAdsService._();

  static final GoogleAdsService instance = GoogleAdsService._();

  AppOpenAd? _onAppOpenAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  RewardedInterstitialAd? _rewardedInterstitialAd;

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    _loadOnAppOpenAds();
    _loadInterstitialAds();
    _loadRewardedAds();
    _loadRewardedInterstitialAds();
  }

  void _loadOnAppOpenAds() async {
    try {
      await AppOpenAd.load(
        adUnitId: "ca-app-pub-5144818645068601/4051045125",
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            _onAppOpenAd = ad;
          },
          onAdFailedToLoad: (error) {
            debugPrint("Failed to load the interstitial ads: $error");
          },
        ),
      );
    } catch (e) {
      debugPrint("Error in loading interstitial ads: $e");
    }
  }

  Future<void> showOnAppOpenAds() async {
    if (_onAppOpenAd != null) {
      _onAppOpenAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _onAppOpenAd = null;
          _loadOnAppOpenAds();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _onAppOpenAd = null;
          _loadOnAppOpenAds();
          debugPrint("❌ Failed to show on app open ad: $error");
        },
      );
      _onAppOpenAd?.show();
    } else {
      _loadOnAppOpenAds();
    }
  }

  void _loadInterstitialAds() async {
    try {
      await InterstitialAd.load(
        adUnitId: "ca-app-pub-5144818645068601/7381406737",
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitialAd = ad;
          },
          onAdFailedToLoad: (error) {
            debugPrint("Failed to load the interstitial ads: $error");
          },
        ),
      );
    } catch (e) {
      debugPrint("Error in loading interstitial ads: $e");
    }
  }

  Future<void> showInterstitialAds() async {
    if (_interstitialAd != null) {
      _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _interstitialAd = null;
          _loadInterstitialAds();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _interstitialAd = null;
          _loadInterstitialAds();
          debugPrint("❌ Failed to show Interstitial Ad: $error");
        },
      );
      _interstitialAd?.show();
    } else {
      _loadInterstitialAds();
    }
  }

  void _loadRewardedAds() async {
    try {
      await RewardedAd.load(
        adUnitId: "ca-app-pub-5144818645068601/8882190665",
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _rewardedAd = ad;
          },
          onAdFailedToLoad: (error) {
            debugPrint("Failed to load rewarded ad: $error");
          },
        ),
      );
    } catch (e) {
      debugPrint("Error in loading rewarded ads: $e");
    }
  }

  Future<void> showRewardedAds({
    required Function(AdWithoutView, RewardItem) onUserEarnedReward,
  }) async {
    if (_rewardedAd != null) {
      _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _rewardedAd = null;
          _loadRewardedAds();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _rewardedAd = null;
          _loadRewardedAds();
          debugPrint("❌ Failed to show Interstitial Ad: $error");
        },
      );
      _rewardedAd?.show(onUserEarnedReward: onUserEarnedReward);
    } else {
      _loadRewardedAds();
    }
  }

  void _loadRewardedInterstitialAds() async {
    try {
      await RewardedInterstitialAd.load(
        adUnitId: "ca-app-pub-5144818645068601/1195272332",
        request: const AdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _rewardedInterstitialAd = ad;
          },
          onAdFailedToLoad: (error) {
            debugPrint("Failed to load rewarded interstitial ad: $error");
          },
        ),
      );
    } catch (e) {
      debugPrint("Error in loading rewarded interstitial ads: $e");
    }
  }

  Future<void> showRewardedInterstitialAds({
    required Function(AdWithoutView, RewardItem) onUserEarnedReward,
  }) async {
    if (_rewardedInterstitialAd != null) {
      _rewardedInterstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _rewardedInterstitialAd = null;
          _loadRewardedInterstitialAds();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _rewardedInterstitialAd = null;
          _loadRewardedInterstitialAds();
          debugPrint("❌ Failed to show Interstitial Ad: $error");
        },
      );
      _rewardedInterstitialAd?.show(onUserEarnedReward: onUserEarnedReward);
    } else {
      _loadRewardedInterstitialAds();
    }
  }
}
