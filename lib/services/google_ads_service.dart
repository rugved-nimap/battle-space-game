import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class GoogleAdsService {
  static GoogleAdsService get instance => GoogleAdsService._();

  GoogleAdsService._();

  Future<void> onAppOpenAds() async {
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
  }

  Future<void> interstitialAds() async {
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
  }

  Future<void> rewardedAds({required OnUserEarnedRewardCallback onUserEarnedReward}) async {
    await RewardedAd.load(
      adUnitId: "ca-app-pub-5144818645068601/8882190665",
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.show(onUserEarnedReward: onUserEarnedReward);
        },
        onAdFailedToLoad: (error) {
          debugPrint("Failed to load the rewarded ads: $error");
        },
      ),
    );
  }


  Future<void> rewardedInterstitialAds({required OnUserEarnedRewardCallback onUserEarnedReward}) async {
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
  }
}
