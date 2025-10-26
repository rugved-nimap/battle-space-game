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
        adUnitId: "<YOUR-GOOGLE-ADS-UNIT-ID>",
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
        adUnitId: "<YOUR-GOOGLE-ADS-UNIT-ID>",
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
        adUnitId: "<YOUR-GOOGLE-ADS-UNIT-ID>",
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
        adUnitId: "<YOUR-GOOGLE-ADS-UNIT-ID>",
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

// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
//
// class GoogleAdsService {
//   GoogleAdsService._();
//
//   static final GoogleAdsService instance = GoogleAdsService._();
//
//   Future<void> onAppOpenAds() async {
//     try {
//       await AppOpenAd.load(
//         adUnitId: "ca-app-pub-5144818645068601/4051045125",
//         request: const AdRequest(),
//         adLoadCallback: AppOpenAdLoadCallback(
//           onAdLoaded: (ad) {
//             ad.show();
//           },
//           onAdFailedToLoad: (error) {
//             debugPrint("Failed to load the ads when app opens: $error");
//           },
//         ),
//       );
//     } catch (e) {
//       debugPrint("Error in showing on app open ads: $e");
//     }
//   }
//
//   Future<void> interstitialAds() async {
//     try {
//       await InterstitialAd.load(
//         adUnitId: "ca-app-pub-5144818645068601/7381406737",
//         request: const AdRequest(),
//         adLoadCallback: InterstitialAdLoadCallback(
//           onAdLoaded: (ad) {
//             ad.show();
//           },
//           onAdFailedToLoad: (error) {
//             debugPrint("Failed to load the interstitial ads: $error");
//           },
//         ),
//       );
//     } catch (e) {
//       debugPrint("Error in showing on interstitial ads: $e");
//     }
//   }
//
//   Future<void> rewardedAds({
//     required OnUserEarnedRewardCallback onUserEarnedReward,
//   }) async {
//     final completer = Completer<void>();
//
//     try {
//       await RewardedAd.load(
//         adUnitId: "ca-app-pub-5144818645068601/8882190665",
//         request: const AdRequest(),
//         rewardedAdLoadCallback: RewardedAdLoadCallback(
//           onAdLoaded: (ad) async {
//             ad.fullScreenContentCallback = FullScreenContentCallback(
//               onAdDismissedFullScreenContent: (ad) {
//                 ad.dispose();
//                 if (!completer.isCompleted) completer.complete(); // ad closed
//               },
//               onAdFailedToShowFullScreenContent: (ad, error) {
//                 ad.dispose();
//                 if (!completer.isCompleted) {
//                   completer.complete(); // failed to show
//                 }
//               },
//             );
//
//             await ad.show(onUserEarnedReward: onUserEarnedReward);
//           },
//           onAdFailedToLoad: (error) {
//             debugPrint("Failed to load rewarded ad: $error");
//             if (!completer.isCompleted) completer.complete(); // complete anyway
//           },
//         ),
//       );
//     } catch (e) {
//       debugPrint("Error in showing rewarded ad: $e");
//       if (!completer.isCompleted) completer.complete();
//     }
//
//     // Wait until ad is closed before returning
//     return completer.future;
//   }
//
//   Future<void> rewardedInterstitialAds(
//       {required OnUserEarnedRewardCallback onUserEarnedReward}) async {
//     try {
//       await RewardedInterstitialAd.load(
//         adUnitId: "ca-app-pub-5144818645068601/1195272332",
//         request: const AdRequest(),
//         rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
//           onAdLoaded: (ad) {
//             ad.show(onUserEarnedReward: onUserEarnedReward);
//           },
//           onAdFailedToLoad: (error) {
//             debugPrint("Failed to load the rewarded ads: $error");
//           },
//         ),
//       );
//     } catch (e) {
//       debugPrint("Error in showing rewarded interstitial ads: $e");
//     }
//   }
// }
