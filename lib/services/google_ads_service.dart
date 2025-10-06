import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class GoogleAdsService {
  GoogleAdsService._();

  static final GoogleAdsService instance = GoogleAdsService._();

  Future<void> onAppOpenAds() async {
    try {
      await AppOpenAd.load(
        adUnitId: "ca-app-pub-5144818645068601/4051045125",
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            ad.show();
          },
          onAdFailedToLoad: (error) {
            debugPrint("Failed to load the ads when app opens: $error");
          },
        ),
      );
    } catch (e) {
      debugPrint("Error in showing on app open ads: $e");
    }
  }

  Future<void> interstitialAds() async {
    try {
      await InterstitialAd.load(
        adUnitId: "ca-app-pub-5144818645068601/7381406737",
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            ad.show();
          },
          onAdFailedToLoad: (error) {
            debugPrint("Failed to load the interstitial ads: $error");
          },
        ),
      );
    } catch (e) {
      debugPrint("Error in showing on interstitial ads: $e");
    }
  }

  Future<void> rewardedAds({
    required OnUserEarnedRewardCallback onUserEarnedReward,
  }) async {
    final completer = Completer<void>();

    try {
      await RewardedAd.load(
        adUnitId: "ca-app-pub-5144818645068601/8882190665",
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) async {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
                if (!completer.isCompleted) completer.complete(); // ad closed
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                ad.dispose();
                if (!completer.isCompleted) {
                  completer.complete(); // failed to show
                }
              },
            );

            await ad.show(onUserEarnedReward: onUserEarnedReward);
          },
          onAdFailedToLoad: (error) {
            debugPrint("Failed to load rewarded ad: $error");
            if (!completer.isCompleted) completer.complete(); // complete anyway
          },
        ),
      );
    } catch (e) {
      debugPrint("Error in showing rewarded ad: $e");
      if (!completer.isCompleted) completer.complete();
    }

    // Wait until ad is closed before returning
    return completer.future;
  }

  Future<void> rewardedInterstitialAds(
      {required OnUserEarnedRewardCallback onUserEarnedReward}) async {
    try {
      await RewardedInterstitialAd.load(
        adUnitId: "ca-app-pub-5144818645068601/1195272332",
        request: const AdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            ad.show(onUserEarnedReward: onUserEarnedReward);
          },
          onAdFailedToLoad: (error) {
            debugPrint("Failed to load the rewarded ads: $error");
          },
        ),
      );
    } catch (e) {
      debugPrint("Error in showing rewarded interstitial ads: $e");
    }
  }
}
